const path = require('path');


module.exports = {

  entry: './src/index.coffee',

  output: {
    path: path.resolve(__dirname, 'lib/node'),
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
