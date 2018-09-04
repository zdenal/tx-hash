import { connect } from 'react-redux'
import React from 'react';
import { submitTransaction } from '../actions'

const mapStateToProps = ({ transactions: { transactionErrors } }, ownProps) => {
  return {
    transactionErrors: transactionErrors
  }
}

function renderError(field, error) {
  if(!!error) {
    return (
      <p>{field} {error}</p>
    )
  }
}

function render({submitTransaction, transactionErrors}) {
  return (
    <form onSubmit={(e) => { submitTransaction(e) }} className="form">
      <input type="text" name="txhash" className="input-query" placeholder="Check tx hash in ethereum ..."/>
      <div className="errors">
        { renderError("hash", transactionErrors.hash) }
        { renderError("chain", transactionErrors.chain) }
      </div>
    </form>
  )
}

const TransactionForm = connect(
  mapStateToProps,
  { submitTransaction }
)(render)

export default TransactionForm
