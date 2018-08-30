import {Socket} from "phoenix-socket"

const initialState = {
  counter: 0,
	socket: null,
	channel: null,
  transactions: [],
	fetchedTxs: false,
  transactionErrors: {}
}

export const SET_SOCKET = "SET_SOCKET"
export const INIT_TRANSACTIONS = "INIT_TRANSACTIONS"
export const ADD_TRANSACTION = "ADD_TRANSACTION"
export const UPDATE_TRANSACTION = "UPDATE_TRANSACTION"
export const HANDLE_ERRORS = "HANDLE_ERRORS"

function set_socket(state) {
  const socket = new Socket("ws://localhost:4000/socket", {})
  socket.connect()

  const channel = socket.channel("transaction:lobby")
  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })

  return Object.assign({}, state, {
    socket: socket,
    channel: channel
  })
}

function addTransaction(state, transaction) {
  return Object.assign({}, state, {
    transactionErrors: {},
    transactions: [transaction, ...state.transactions]
  })
}

function updateTransaction(state, transaction) {
  return Object.assign({}, state, {
    transactionErrors: {},
    transactions: state.transactions.map(tx => tx.id === transaction.id ? transaction : tx)
  })
}

function reducer(state = initialState, action) {
  switch (action.type) {
    case INIT_TRANSACTIONS:
      return Object.assign({}, state, {
        fetchedTxs: true,
        transactions: [...(action.transactions.reverse()), ...state.transactions]
      })
    case ADD_TRANSACTION:
      return addTransaction(state, action.transaction)
    case UPDATE_TRANSACTION:
      return updateTransaction(state, action.transaction)
    case HANDLE_ERRORS:
      return Object.assign({}, state, {
        transactionErrors: action.errors
      })
    case SET_SOCKET:
			if (state.socket) {
				return state
			} else {
        const res = set_socket(state)
        console.log(res)
        return res
			}
    default:
      return state
  }
}

export default reducer
