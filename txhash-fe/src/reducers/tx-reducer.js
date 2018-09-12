import { createReducer } from 'reduxsauce'
import { Types as ReduxSauceTypes } from 'reduxsauce'
import { Types } from '../actions'

//import { INIT_TRANSACTIONS, ADD_TRANSACTION, UPDATE_TRANSACTION, HANDLE_ERRORS } from '../actions'

const INITIAL_STATE = {
  list: [],
  transactionErrors: {}
}

export const initTransactions = (state = INITIAL_STATE, action) => {
  return { ...state, list: [...(action.transactions.reverse()), ...state.list] }
}

export const addTransaction = (state = INITIAL_STATE, action) => {
  return { ...state, list: [action.transaction, ...state.list], transactionErrors: {}}
}

export const updateTransaction = (state = INITIAL_STATE, action) => {
  return {
    ...state,
    transactionErrors: {},
    list: state.list.map(tx => tx.id === action.transaction.id ? action.transaction : tx)
  }
}

export const handleErrors = (state = INITIAL_STATE, action) => {
  return { ...state, transactionErrors: action.errors}
}

export const defaultHandler = (state = INITIAL_STATE, action) => {
  return state
}

export default createReducer(INITIAL_STATE, {
  [ReduxSauceTypes.DEFAULT]: defaultHandler,
  [Types.INIT_TRANSACTIONS]: initTransactions,
  [Types.ADD_TRANSACTION]: addTransaction,
  [Types.UPDATE_TRANSACTION]: updateTransaction,
  [Types.HANDLE_ERRORS]: handleErrors
})
