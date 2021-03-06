import { connect } from 'react-redux'
import React from 'react';
import { Creators } from '../actions'

const mapStateToProps = ({ transactions: { transactionErrors } }, ownProps) => {
  return {
    transactionErrors: transactionErrors
  }
}

const mapDispatchToProps = (dispatch) => ({
  submitTransaction: (event) => {
    event.preventDefault()
    const data = new FormData(event.target)
    dispatch(Creators.sendTransaction(data.get('txhash'), 'ethereum'))

    // TODO: quick BAAAAAAD hack. Should be managed by redux.
    event.target.getElementsByTagName('input')[0].value = ""
  }
})

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
  mapDispatchToProps
)(render)

export default TransactionForm
