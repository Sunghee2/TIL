import React, { Component } from 'react';
import axios from 'axios';
import logo from './logo.svg';
import './App.css';

class App extends Component {
  constructor(props) {
    super(props);

    this.state = {
      posts: []
    }
    axios.get('/api/posts').then(response => {
      this.setState({posts: response.data});
    });
  }

  renderPost(post) {
    return (
      <li key={post.id}>{post.title} by {post.name}</li>
    );
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <div className="App-intro">
          <ul>
            {this.state.posts.map(this.renderPost)}
          </ul>
        </div>
      </div>
    );
  }
}

export default App;
