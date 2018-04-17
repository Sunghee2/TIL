const express = require('express');
const logger = require('morgan');
const bodyParser = require('body-parser');
const routes = require('./routes');

const app = express();
app.use(logger('dev'));

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

const port = process.env.PORT || 3001;

app.use('/api', routes);
app.listen(port, ()=> {
  console.log('Listen on port ${port}.');
});