const express = require('express');
const logger = require('morgan');
const bodyParser = require('body-parser');
const routes = require('./routes');

const app = express();
app.use(logger('dev'));

app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());

// app.set('view engine', 'html');

const port = process.env.PORT || 3001;

app.use('/api', routes);
app.listen(port, ()=> {
  console.log(`Listen on port ${port}.`);
});

app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

app.use(function (err, req, res, next){
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development'? err: {};

  res.status(err.status || 500);
  res.render('error');
})