webpack = require 'webpack'


module.exports =
  entry: [
      "#{__dirname}/main.coffee"
  ]
  devtool: 'inline-source-map'
  debug: false
  output:
    path: "#{__dirname}"
    filename: 'main.js'
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
