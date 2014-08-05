_ = require 'underscore'
requireConfig = require './require-config.json'

# https://github.com/jrburke/r.js/blob/master/build/example.build.js
rjsOptions = _.extend {}, requireConfig,
  name: 'index'
  include: ['../../../bower_components/almond/almond']
  findNestedDependencies: true

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-bump'
  grunt.loadNpmTasks 'grunt-csso'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'

  grunt.initConfig
    pkg: require './package.json'
    component: require './bower.json'

    clean:
      dist       : ['dist']
      css        : ['build/css']
      popup      : ['build/src/popup']
      background : ['build/src/background']

    coffee:
      popup:
        expand: true
        flatten: false
        cwd: 'src/popup'
        src: ['**/*.coffee']
        dest: 'build/src/popup/'
        ext: '.js'
      background:
        expand: true
        flatten: false
        cwd: 'src/background'
        src: ['**/*.coffee']
        dest: 'build/src/background/'
        ext: '.js'

    requirejs:
      popup:
        options: (_.extend {
          out: 'dist/popup.js'
          baseUrl: 'build/src/popup'
        }, rjsOptions)
      background:
        options: (_.extend {
          out: 'dist/background.js'
          baseUrl: 'build/src/background'
        }, rjsOptions)

    less:
      main:
        files:
          'build/css/popup.less.css': 'assets/less/popup.less'

    autoprefixer:
      main:
        src: 'build/css/popup.less.css'
        dest: 'build/css/popup.ap.less.css'

    csso:
      main:
        files:
          'build/css/popup.csso.ap.less.css': 'build/css/popup.ap.less.css'

    watch:
      styles:
        files: ['assets/less/**/*.less']
        tasks: ['styles']
      popup:
        files: ['src/popup/**/*.coffee']
        tasks: ['popup']
      background:
        files: ['src/background/**/*.coffee']
        tasks: ['background']

    bump:
      options:
        push: false
        commit: false
        createTag: false
        files: ['package.json', 'bower.json']
        updateConfigs: ['pkg', 'component']

  grunt.registerTask 'styles', [
    'clean:css'
    'less'
    'autoprefixer'
    'csso'
  ]

  grunt.registerTask 'popup', [
    'clean:popup'
    'coffee:popup'
    'requirejs:popup'
  ]

  grunt.registerTask 'background', [
    'clean:background'
    'coffee:background'
    'requirejs:background'
  ]

  grunt.registerTask 'default', [
    'popup'
    'background'
    'styles'
  ]

  grunt.registerTask 'live', [
    'default'
    'watch'
  ]
