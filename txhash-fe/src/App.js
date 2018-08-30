import React, { Component } from 'react';
import './App.css';
import './Custom.css';
import Transactions from './Transactions';

class App extends Component {
  render() {
    return (
      <div className="container">
        <Transactions />
      </div>
    );
  }
}

export default App;
