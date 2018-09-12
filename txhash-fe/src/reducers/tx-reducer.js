import { INIT_TRANSACTIONS, ADD_TRANSACTION, UPDATE_TRANSACTION, HANDLE_ERRORS } from '../actions'

const initialState = {
  list: [],
  transactionErrors: {}
}

export default (state = initialState, action) => {
  switch (action.type) {
    case INIT_TRANSACTIONS:
      return { ...state, list: [...(action.transactions.reverse()), ...state.list], fetchedTxs: true }
    case ADD_TRANSACTION:
      return { ...state, list: [action.transaction, ...state.list], transactionErrors: {}}
    case UPDATE_TRANSACTION:
      return {
        ...state,
        transactionErrors: {},
        list: state.list.map(tx => tx.id === action.transaction.id ? action.transaction : tx)
      }
    case HANDLE_ERRORS:
      return { ...state, transactionErrors: action.errors}
    default:
      return state
  }
};
