import React, {Component} from 'react';
import {connect} from 'react-redux';

class WeatherList extends Component {
  renderList(weathers) {
    if(!weathers) {
      return <div></div>;
    }
    return weathers.map(weather => (
      <tr>
        <td scope="row">{weather.city}</td>
        <td>{weather.temperature}</td>
        <td>{weather.pressure}</td>
        <td>{weather.humidity}</td>
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
    weathers
  };
}

export default connect(mapStateToProps)(WeatherList);