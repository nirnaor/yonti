module.exports = (grunt)->
  config = {}

  config.coffee =
    glob_to_multiple:
      expand: true,
      flatten: false, #keep folder structure when compiling
      cwd: 'app',
      src: ['**/*.coffee' ],
      dest: coffee_output
      ext: '.js'


