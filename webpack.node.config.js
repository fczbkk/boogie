module.exports = {

  entry: './src/index.coffee',

  output: {
    path: './temp/lib/node/',
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
