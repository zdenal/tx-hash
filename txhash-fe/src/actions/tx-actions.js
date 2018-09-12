export const SET_SOCKET = "SET_SOCKET"
export const SET_CHANNEL = "SET_CHANNEL"
export const INIT_TRANSACTIONS = "INIT_TRANSACTIONS"
export const ADD_TRANSACTION = "ADD_TRANSACTION"
export const SEND_TRANSACTION = "SEND_TRANSACTION"
export const UPDATE_TRANSACTION = "UPDATE_TRANSACTION"
export const HANDLE_ERRORS = "HANDLE_ERRORS"

export const initTransactions = (transactions) => {
  return {
    type: INIT_TRANSACTIONS,
    transactions: transactions
  }
}

export const handleErrors = (errors) => {
  return {
    type: HANDLE_ERRORS,
    errors: errors
  }
}

export const sendTransaction = ({ hash, chain }) => {
  return {
    type: SEND_TRANSACTION,
    hash: hash,
    chain: chain
  }
}

export const addTransaction = (transaction) => {
  return {
    type: ADD_TRANSACTION,
    transaction: transaction
  }
}

export const updateTransaction = (transaction) => {
  return {
    type: UPDATE_TRANSACTION,
    transaction: transaction
  }
}
