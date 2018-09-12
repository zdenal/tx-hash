import { connect } from 'react-redux'
import React from 'react'
import Transaction from './Transaction'
import Form from './Form'
import { Creators } from '../actions'


const mapStateToProps = ({ transactions: { list, channel} }, ownProps) => {
  return {
    transactions: list,
    channel: channel
  }
}

const mapDispatchToProps = dispatch => ({
  initChannel: () => dispatch(Creators.setChannel())
})

class ConnectedTransactions extends React.Component {
  componentDidMount() {
    this.props.initChannel()
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
