module.exports = (grunt)->
  for task in [ 'grunt-contrib-coffee' , 'grunt-browserify',
  'grunt-contrib-watch' ]
    grunt.loadNpmTasks task


  config = {}

  config.watch =
    code:
      files: "scripts/**/*.coffee"
      tasks: [ "code" ]
      options: livereload: 35729
  

  coffee_output = "build"
  config.coffee =
    glob_to_multiple:
      expand: true,
      flatten: false, #keep folder structure when compiling
      cwd: 'scripts',
      src: ['**/*.coffee' ],
      dest: coffee_output
      ext: '.js'

  config.browserify =
    main:
      src: "#{coffee_output}/index.js"
      dest: "#{coffee_output}/browserified.js"






  grunt.initConfig config
  grunt.registerTask("code", [ "coffee", "browserify" ])


