const path = require('path');


module.exports = {

  entry: './src/index.coffee',

  output: {
    path: path.resolve(__dirname, 'lib/browser'),
    filename: 'index.js',
    library: 'Boogie',
    libraryTarget: 'umd'
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
