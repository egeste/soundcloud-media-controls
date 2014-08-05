_ = require 'underscore'
requireConfig = require './require-config.json'

# https://github.com/jrburke/r.js/blob/master/build/example.build.js
rjsOptions = _.extend {}, requireConfig,
  out: 'dist/background.js'
  name: 'index'
  baseUrl: 'build/src'
  include: ['../../bower_components/almond/almond']
  findNestedDependencies: true

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-contib-bump'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'

  grunt.initConfig
    pkg: require './package.json'
    component: require './bower.json'

    clean:
      docs  : ['docs']
      dist  : ['dist']
      build : ['build']

    coffee:
      src:
        expand: true
        flatten: false
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'build/src/'
        ext: '.js'

    requirejs:
      dev: options: (_.extend { optimize: 'none' }, rjsOptions)
      rel: options: (_.extend { optimize: 'uglify2' }, rjsOptions)

    watch:
      src:
        files: ['src/**/*.coffee']
        tasks: ['default']

    bump:
      options:
        push: false
        commit: false
        createTag: false
        files: ['package.json', 'bower.json']
        updateConfigs: ['pkg', 'component']

  grunt.registerTask 'default', [
    'clean:build'
    'coffee'
    'requirejs:dev'
  ]

  grunt.registerTask 'live', [
    'default'
    'watch'
  ]
