import axios from 'axios';
export const FETCH_POSTS = 'fetch_posts';
export const FETCH_POST = 'fetch_post';
export const CREATE_POST = 'create_post';
export const DELETE_POST = 'delete_post';

export function fetchPosts() {
  return {
    type: FETCH_POSTS,
    payload: axios.get('/api/posts/')
  };
}

export function fetchPost(id) {
  return {
    type: FETCH_POST,
    payload: axios.get(`/api/posts/${id}`)
  };
}

export function createPost(values, callback) {
  const request = axios.post('/api/posts', values).then(() => callback());

  return {
    type: CREATE_POST,
    payload: request
  };
}

export function deletePost(id, callback) {
  const request = axios.delete(`/api/posts/${id}`).then(() => callback());
  
  return {
    type: DELETE_POST,
    payload: id
  };
}