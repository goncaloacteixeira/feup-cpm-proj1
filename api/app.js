const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const bodyParser = require('body-parser');


const indexRouter = require('./routes/index');
const usersRouter = require('./routes/users');
const itemsRouter = require('./routes/items');


const app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);
app.use('/items', itemsRouter);


app.use(bodyParser.json());


module.exports = app;