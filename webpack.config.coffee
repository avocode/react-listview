webpack = require 'webpack'


module.exports =
  entry: [
      "#{__dirname}/src/index.coffee"
  ]
  devtool: 'inline-source-map'
  debug: false
  output:
    path: "#{__dirname}/dist"
    filename: 'index.js'
  resolve:
    extensions: ['', '.coffee', '.js']
  resolveLoader:
    modulesDirectories: ['node_modules']
  module:
    loaders: [
      {
        test: /\.coffee$/
        loader: 'coffee'
      }
    ]
