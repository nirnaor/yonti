module.exports = (grunt)->
  for task in [ 'grunt-contrib-coffee' ] 
    grunt.loadNpmTasks task


  config = {}

  coffee_output = "build"
  config.coffee =
    glob_to_multiple:
      expand: true,
      flatten: false, #keep folder structure when compiling
      cwd: 'scripts',
      src: ['**/*.coffee' ],
      dest: coffee_output
      ext: '.js'



  grunt.initConfig config


