module.exports = (grunt)->
  for task in [ 'grunt-contrib-coffee' , 'grunt-browserify',
  'grunt-contrib-watch', 'grunt-jade-plugin' ]
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
      src: "#{coffee_output}/app.js"
      dest: "#{coffee_output}/browserified.js"


  # Templates
  jade_files= {}
  jade_output  = "build/templates.js"
  jade_files[ jade_output ] =["templates/*.jade"]
  config.jade2js =
    compile:
      options:
        namespace: "JST"
      files: jade_files






  grunt.initConfig config
  grunt.registerTask("code", [ "coffee", "browserify" ])
  grunt.registerTask("templates", [ "jade2js" ])


