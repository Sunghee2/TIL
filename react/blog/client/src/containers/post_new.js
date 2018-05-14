import React, { Component } from 'react';
import axios from 'axios';
import {Link} from 'react-router-dom';

class PostNew extends Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    event.preventDefault();
    setTimeout(() => {
      this.props.history.push('/');
    }, 1000)
  }

  render() {
    return(
      <div className = 'post-new'>
        <h1>New Post</h1>
        <div className="text-right">
          <Link to='/' className="btn btn-secondary">List</Link>
        </div>
        <form onSubmit={this.handleSubmit}>
          <div className="form-group">
            <label>Name</label>
            <input type="text" className="form-control" name="name"/>
          </div>
          <div className="form-group">
            <label>Title</label>
            <input type="text" className="form-control" name="title"/>
          </div>
          <div className="form-group">
            <label>Content</label>
            <textarea className="form-control" name="content" row="4"/>
          </div>
          <button type='submit' className="btn btn-primary">Post</button>
        </form>
      </div>
    );
  }
}

export default PostNew;