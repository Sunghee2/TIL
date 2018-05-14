import _ from 'lodash';
import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import {connect} from 'react-redux';
import {fetchPosts} from '../actions';
import moment from 'moment';

class PostList extends Component {
  componentDidMount() {
    this.props.fetchPosts();
  }

  render() {
    return (
      <div className = 'post-new'>
        <h1>Posts</h1>
        <div className="text-right">
          <Link to="/new" className="btn btn-primary">New Post</Link>
        </div>
        <table className="table mt-3">
          <thead>
            <tr>
              <th scope="col">제목</th>
              <th scope="col">글쓴이</th>
              <th scope="col">날짜</th>
            </tr>
          </thead>
          <tbody>
            {_.map(this.props.posts, ({id, title, name, createdAt}) => (
              <tr key = {id}>
                <td><Link to = {`/${id}`}>{title}</Link></td>
                <td>{name}</td>
                <td>{moment(createdAt).format('YYYY-MM-DD')}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }
}

export default PostList;