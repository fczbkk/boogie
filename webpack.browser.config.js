module.exports = {

  entry: './src/index.coffee',

  output: {
    path: './lib/browser/',
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
