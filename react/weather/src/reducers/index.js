import {combineReducers} from 'redux';
import weathers from './weather_reducer';

const rootReducer = combineReducers({
  weathers
});

export default rootReducer;