import {Socket} from "phoenix-socket"

export const SET_SOCKET = "SET_SOCKET"
export const INIT_TRANSACTIONS = "INIT_TRANSACTIONS"
export const ADD_TRANSACTION = "ADD_TRANSACTION"
export const UPDATE_TRANSACTION = "UPDATE_TRANSACTION"
export const HANDLE_ERRORS = "HANDLE_ERRORS"

export const setChannel = () => {
  const socket = new Socket("ws://localhost:4000/socket", {})
  socket.connect()

  const channel = socket.channel("transaction:lobby")
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  return {
    type: SET_SOCKET,
    socket: socket,
    channel: channel
  }
}

export const submitTransaction = (event) => {
  return (dispatch, getState) => {
    event.preventDefault()
    const data = new FormData(event.target)
    const { transactions: { channel } } = getState()

    const params = {
      hash: data.get('txhash'),
      chain: 'ethereum'
    }

    // TODO: quick BAAAAAAD hack. Should be managed by redux.
    event.target.getElementsByTagName('input')[0].value = ""

    channel.push("create", params)
      .receive("error", resp => { dispatch(handleErrors(resp.errors)) })
  }
}

export const initChannel = () => {
  return (dispatch, getState) => {
    const { transactions: { channel } } = getState()

    if(!channel) { dispatch(setChannel()) }
  }
}

export const registerTransactionsHooks = () => {
  return (dispatch, getState) => {
    const { transactions: { channel, fetchedTxs } } = getState()

    if(!!channel && !fetchedTxs) {
      channel.on("new_transaction", resp => { dispatch(addTransaction(resp.data)) })
      channel.on("processed_tx", resp => { dispatch(updateTransaction(resp.data)) })

      channel.push("list")
        .receive("ok", resp => { dispatch(initTransactions(resp.data)) })
    }
  }
}

// PRIVATE FUNCTIONS
const initTransactions = (transactions) => {
  return {
    type: INIT_TRANSACTIONS,
    transactions: transactions
  }
}

const handleErrors = (errors) => {
  return {
    type: HANDLE_ERRORS,
    errors: errors
  }
}

const addTransaction = (transaction) => {
  return {
    type: ADD_TRANSACTION,
    transaction: transaction
  }
}

const updateTransaction = (transaction) => {
  return {
    type: UPDATE_TRANSACTION,
    transaction: transaction
  }
}
