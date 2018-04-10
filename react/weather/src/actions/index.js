import axios from 'axios';

const API_KEY = 'f24ae8d7f797c65bf93a9e2b9d3548bd';
const ROOT_URL = 'http://api.openweathermap.org/data/2.5/forecast';

export const FETCH_WEATHER = 'FETCH_WEATHER';

export function fetchWeather(city) {
  const url = `${ROOT_URL}?q=${city}&appid=${API_KEY}`;
  const request = axios.get(url);

  return {
    type: FETCH_WEATHER,
    payload: request
  };
}