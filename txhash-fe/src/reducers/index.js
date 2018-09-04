import { combineReducers } from 'redux';
import TxReducer from './tx-reducer';

export default combineReducers({
  transactions: TxReducer
});

