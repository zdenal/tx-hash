import { connect } from 'react-redux'
import React from 'react'
import Transaction from './Transaction'
import Form from './Form'
import { initChannel, registerTransactionsHooks } from '../actions'

const mapStateToProps = ({ transactions: { list, channel} }, ownProps) => {
  return {
    transactions: list,
    channel: channel
  }
}

class ConnectedTransactions extends React.Component {
  componentDidMount() {
    this.props.initChannel()
  }

  componentDidUpdate(prevProps, prevState) {
    this.props.registerTransactionsHooks()
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
  { initChannel, registerTransactionsHooks }
)(ConnectedTransactions)

export default Transactions
