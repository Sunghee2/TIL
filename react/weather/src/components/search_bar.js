import React, {Component} from 'react';

export default class SearchBar extends Component {
  render() {
    return(
      <div className="row">
        <input className="col-11" type="text" placeholder="city"/>
        <button className="btn btn-primary" type="button">Search</button>
      </div>
    );
  }
}