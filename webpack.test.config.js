const path = require('path');

module.exports = {

  entry: './test/index.spec.coffee',

  output: {
    path: path.resolve(__dirname, 'temp/test'),
    filename: 'index.js'
  },

  module: {

    loaders: [
      {
        test: /\.coffee$/,
        loaders: ['babel-loader', 'coffee-loader']
      },
      {
        test: /\.js$/,
        loaders: ['babel-loader']
      }
    ]

  }

};
