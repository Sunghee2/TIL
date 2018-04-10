import React, {Component} from 'react';
import {connect} from 'react-redux';
import GoogleMap from './google_map';

class WeatherList extends Component {
  renderList(weathers) {
    if(!weathers) {
      return <div></div>;
    }
    return weathers.map(weather => (
      <tr key={weather.city.id}>
        <td scope="row">
          <GoogleMap lat={weather.city.coord.lat} lng={weather.city.coord.lon}/>
        </td>
        <td>{Math.round(weather.list[0].main.temp-273.15, 1)}</td>
        <td>{weather.list[0].main.pressure}</td>
        <td>{weather.list[0].main.humidity}</td>
      </tr>
    ));
  }

  render(){
    return (
      <table className="table text-center">
        <thead>
          <tr>
            <th scope="col">City</th>
            <th scope="col">Temperature(˚C)</th>
            <th scope="col">Pressure(hPa)</th>
            <th scope="col">Humidity(%)</th>
          </tr>
        </thead>
        <tbody>
          {this.renderList(this.props.weathers)}
        </tbody>
      </table>
    );
  }
}

function mapStateToProps({weathers}) {
  return {
    weathers: weathers.data
  };
}

export default connect(mapStateToProps)(WeatherList);