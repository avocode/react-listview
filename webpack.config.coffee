webpack = require 'webpack'

module.exports =
  entry: [
      "#{__dirname}/example/main.coffee"
  ]
  devtool: 'inline-source-map'
  debug: true
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
