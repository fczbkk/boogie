module.exports = {

  entry: './test/index.spec.coffee',

  output: {
    path: './temp/test/',
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
