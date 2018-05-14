import React, { Component } from 'react';
import axios from 'axios';
import {Route, Switch} from "react-router-dom";

import PostList from './containers/post_list';
import PostDetails from './containers/post_details';
import PostNew from './containers/post_new';
import './App.css';

class App extends Component {

  render() {
    return (
      <div className="App">
        <Switch>
          <Route exact path='/' component={PostList}/>
          <Route path='/new' component={PostNew}/>
          <Route path='/:id' component={PostDetails}/>
        </Switch>
      </div>
    );
  }
}

export default App;
