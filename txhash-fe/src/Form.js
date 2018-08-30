import { connect } from 'react-redux'
import React from 'react';
import { HANDLE_ERRORS } from './reducers'

const mapStateToProps = (state, ownProps) => {
  return {
    channel: state.channel,
    transactionErrors: state.transactionErrors
  }
}

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    handleSubmit: (event, channel) => {
      event.preventDefault()
      const data = new FormData(event.target)

      const params = {
        hash: data.get('txhash'),
        chain: 'ethereum'
      }

      // TODO: quick BAAAAAAD hack. Should be managed by redux.
      event.target.getElementsByTagName('input')[0].value = ""

      channel.push("create", params)
        .receive("error", resp => { dispatch({type: HANDLE_ERRORS, errors: resp.errors}) })
    }
  }
}

function render({handleSubmit, transactionErrors, channel}) {
  return (
    <form onSubmit={(e) => { handleSubmit(e, channel) }} className="form">
      <input type="text" name="txhash" className="input-query" placeholder="Check tx hash in ethereum ..."/>
      <div className="errors">
        { !!transactionErrors.hash &&
          <p>hash {transactionErrors.hash}</p>
        }
        { !!transactionErrors.chain &&
            <p>chain {transactionErrors.chain}</p>
        }
      </div>
    </form>
  )
}

const TransactionForm = connect(
  mapStateToProps,
  mapDispatchToProps
)(render)

export default TransactionForm

