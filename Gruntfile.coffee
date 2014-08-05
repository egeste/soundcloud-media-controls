_ = require 'underscore'
requireConfig = require './require-config.json'

config = require './config.json'

# https://github.com/jrburke/r.js/blob/master/build/example.build.js
rjsOptions = _.extend {}, requireConfig,
  name: 'index'
  include: ['../../../bower_components/almond/almond']
  findNestedDependencies: true

module.exports = (grunt) ->
  grunt.loadNpmTasks 'grunt-csso'
  grunt.loadNpmTasks 'grunt-bumpx'
  grunt.loadNpmTasks 'grunt-autoprefixer'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-build-crx'
  grunt.loadNpmTasks 'grunt-contrib-requirejs'

  grunt.initConfig
    pkg: require './package.json'
    component: require './bower.json'

    clean:
      dist       : ['dist']
      css        : ['build/css']
      popup      : ['build/src/popup']
      shared     : ['build/src/shared']
      background : ['build/src/background']

    coffee:
      shared:
        expand: true
        flatten: false
        cwd: 'src/shared'
        src: ['**/*.coffee']
        dest: 'build/src/shared/'
        ext: '.js'
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
          'dist/popup.css': 'build/css/popup.ap.less.css'

    watch:
      shared:
        files: ['src/shared/**/*.coffee']
        tasks: ['shared']
      popup:
        files: ['src/popup/**/*.coffee']
        tasks: ['popup']
      background:
        files: ['src/background/**/*.coffee']
        tasks: ['background']
      styles:
        files: ['assets/less/**/*.less']
        tasks: ['styles']

    bump:
      files: [
        'bower.json'
        'package.json'
        'manifest.json'
      ]
      options:
        level: 'patch'
        onBumped: (data) ->
          currentFile = data.task.filesSrc[data.index]
          if /package.json/.test currentFile
            grunt.config 'pkg', grunt.file.readJSON currentFile
          if /bower.json/.test currentFile
            grunt.config 'component', grunt.file.readJSON currentFile

    'chrome-extension':
      options:
        cwd: '.'
        name: 'SoundCloud Media Controls'
        clean: true
        chrome: config.GOOGLE_CHROME_BINARY
        crxPath: 'build/extension/scmc-<%= pkg.version %>.crx'
        zipPath: 'build/extension/scmc-<%= pkg.version %>.zip'
        certPath: config.KEY_PEM
        buildDir: 'build/extension/scmc'
        cleanPath: 'build/extension/scmc'
        resources: [
          'dist/**'
          'html/**'
          'images/**'
          'scripts/**'
          '_locales/**'
          'updates.xml'
          'manifest.json'
        ]

  grunt.registerTask 'styles', [
    'clean:css'
    'less'
    'autoprefixer'
    'csso'
  ]

  grunt.registerTask 'shared', [
    'clean:shared'
    'coffee:shared'
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
    'shared'
    'popup'
    'background'
    'styles'
  ]

  grunt.registerTask 'package', [
    'bump'
    'default'
    'chrome-extension'
  ]

  grunt.registerTask 'live', [
    'default'
    'watch'
  ]
