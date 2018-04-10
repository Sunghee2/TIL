import {combineReducers} from 'redux';
import weathers from './weather';

const rootReducer = combineReducers({
  weathers
});

export default rootReducer;