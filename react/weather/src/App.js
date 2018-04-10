import React, { Component } from 'react';
import './App.css';
import SearchBar from './components/search_bar';
import WeatherList from './components/weather_list';

class App extends Component {
  render() {
    return (
      <div className="App">
        <div className="SearchBar">
          <SearchBar/>
        </div>
        <div className="weatherList">
          <WeatherList/>
        </div>
      </div>
    );
  }
}

export default App;
