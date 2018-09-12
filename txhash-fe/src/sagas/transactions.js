import { Socket } from "phoenix-socket"
import { take, put, call, fork} from 'redux-saga/effects'
import { eventChannel } from 'redux-saga'
import {
  SET_CHANNEL,
  SEND_TRANSACTION,
  initTransactions,
  addTransaction,
  updateTransaction,
  handleErrors
} from '../actions'

function connect() {
  const socket = new Socket("ws://localhost:4000/socket", {})
  socket.connect()

  const channel = socket.channel("transaction:lobby")
  return new Promise(resolve => {
    channel.join().receive("ok", resp => {
      resolve(channel);
    });
  });
}

function getTransactions(channel) {
  return new Promise(resolve => {
    channel.push('list').receive("ok", resp => {
      resolve(resp.data);
    });
  });
}

function sendTransaction({channel, params}) {
  return new Promise(( resolve, reject ) => {
    channel.push("create", params).receive("error", resp => {
      reject(resp.errors)
    })
  });
}

function* read(channel) {
  const eChannel = yield call(subscribe, channel);
  while (true) {
    let action = yield take(eChannel);
    yield put(action);
  }
}

function* createTransaction(channel) {
  while (true) {
    const {hash, chain} = yield take(SEND_TRANSACTION)

    try {
      yield call(sendTransaction, {channel, params: {hash, chain}})
    } catch (errors) {
      yield put(handleErrors(errors))
    }
  }
}

export function subscribe(channel) {
  return new eventChannel(emit => {
    const newTx = resp => emit(addTransaction(resp.data))
    channel.on('new_transaction', newTx)
    const updateTx = resp => emit(updateTransaction(resp.data))
    channel.on('processed_tx', updateTx)
    return () => {}
  })
}

export default function* root() {
  yield take(SET_CHANNEL)
  const channel = yield call(connect)

  const transactions = yield call(getTransactions, channel)
  yield put(initTransactions(transactions))

  yield fork(read, channel)
  yield fork(createTransaction, channel)
}
