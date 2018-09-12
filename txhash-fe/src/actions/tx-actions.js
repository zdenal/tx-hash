import { createActions } from 'reduxsauce'

export const { Types, Creators } = createActions({
  setChannel: null,
  initTransactions: ['transactions'],
  handleErrors: ['errors'],
  sendTransaction: ['hash', 'chain'],
  addTransaction: ['transaction'],
  updateTransaction: ['transaction']
}, {})
