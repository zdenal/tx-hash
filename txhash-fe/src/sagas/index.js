import { fork } from 'redux-saga/effects'
import transactions from './transactions'

export default function *root() {
  yield fork(transactions)
}
