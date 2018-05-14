import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import axios from 'axios';

class PostDetails extends Component {
  constructor(props) {
    super(props);
  }

  render() {
    console.log(this.props.match);
    return(
      <div className = 'post-details'>
        <h1>제목 - {this.props.match.params.id}</h1>
        <div className="text-right">
          <Link className="btn btn-secondary" to = '/'>List</Link>
        </div>
        <blockquote className="blockquote mt-3">
          <p className="mb-0">test~</p>
          <footer className="blockquote-footer">by someone <cite title = 'Source title'>2018-04-26</cite></footer>
        </blockquote>
      </div>
    );
  }
}

export default PostDetails;
