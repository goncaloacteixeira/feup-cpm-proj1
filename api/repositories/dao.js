const sqlite3 = require('sqlite3').verbose();
const db = new sqlite3.Database('db.sqlite3');
const bcrypt = require('bcrypt');
const saltRounds = 10;

exports.all = (stmt, params) => {
  return new Promise((res, rej) => {
    db.all(stmt, params, (error, result) => {
      if (error) {
        return rej(error.message);
      }
      return res(result);
    });
  })
}
exports.get = (stmt, params) => {
  return new Promise((res, rej) => {
    db.get(stmt, params, (error, result) => {
      if (error) {
        return rej(error.message);
      }
      return res(result);
    });
  })
}

exports.run = (stmt, params) => {
  return new Promise((res, rej) => {
    db.run(stmt, params, (error, result) => {
      if (error) {
        return rej(error.message);
      }
      return res(result);
    });
  })
}