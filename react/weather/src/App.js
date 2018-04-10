import React, { Component } from 'react';
import './App.css';
import {connect} from 'react-redux';
import SearchBar from './components/search_bar';
import WeatherList from './components/weather_list';

class App extends Component {
  handleError(){
    if(this.props.error) {
      return (
        <div className="alert alert-danger" role="alert">
          {this.props.error.message}
        </div>
      );
    }
  }

  render() {
    return (
      <div className="App container mt-3">
        <div className="SearchBar">
          <SearchBar/>
        </div>
        <div className="weatherList">
          {this.handleError()}
          <WeatherList/>
        </div>
      </div>
    );
  }
}

function mapStateToProps(state) {
  return {
    error: state.weathers.error
  };
}

export default connect(mapStateToProps)(App);
