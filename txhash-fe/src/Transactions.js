import { connect } from 'react-redux'
import React from 'react'
import Transaction from './Transaction'
import Form from './Form'
import {SET_SOCKET, INIT_TRANSACTIONS, ADD_TRANSACTION, UPDATE_TRANSACTION} from './reducers'

const mapStateToProps = (state, ownProps) => {
  return {
    transactions: state.transactions,
    channel: state.channel,
    fetchedTxs: state.fetchedTxs
  }
}

const mapDispatchToProps = (dispatch, ownProps) => {
  return {
    initTransactions: (transactions) => {
      dispatch({type: INIT_TRANSACTIONS, transactions: transactions})
    },

    dispatchTxEvent: (action, transaction) => {
      dispatch({type: action, transaction: transaction})
    },

    setChannel: () => {
      dispatch({type: SET_SOCKET})
    }
  }
}

class ConnectedTransactions extends React.Component {
  componentDidMount() {
    const { channel, setChannel } = this.props

    if(!channel) { setChannel() }
  }

  componentDidUpdate(prevProps, prevState) {
    const { channel, fetchedTxs, initTransactions, dispatchTxEvent } = this.props

    if(!!channel && !fetchedTxs) {
      channel.on("new_transaction", resp => { dispatchTxEvent(ADD_TRANSACTION, resp.data) })
      channel.on("processed_tx", resp => { dispatchTxEvent(UPDATE_TRANSACTION, resp.data) })

      channel.push("list")
        .receive("ok", resp => { initTransactions(resp.data) })
    }
  }

  render() {
    console.log(this.props)
    const { transactions } = this.props

    return (
      <div className="transactions">
        <Form />
        <div className="list-wrap">
          <ul className="list">
            {transactions.map((tx) => <Transaction key={tx.id} tx={tx} />)}
          </ul>
        </div>
      </div>
    )
  }
}

const Transactions = connect(
  mapStateToProps,
  mapDispatchToProps
)(ConnectedTransactions)

export default Transactions
