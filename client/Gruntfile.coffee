_ = require "underscore"
module.exports = (grunt)->
  for task in [ 'grunt-contrib-coffee' , 'grunt-browserify',
  'grunt-contrib-watch', 'grunt-jade-plugin', 'grunt-contrib-copy',
  'grunt-shell']
    grunt.loadNpmTasks task


  config = {}

  app_folder = "app"
  config.watch =
    code:
      files: "#{app_folder}/**/*.coffee"
      tasks: [ "code" ]
      options: livereload: 35729
    templates:
      files: "#{app_folder}/**/*.jade"
      tasks: [ "templates" ]
      options: livereload: 35729

  

  coffee_output = "build"
  config.coffee =
    glob_to_multiple:
      expand: true,
      flatten: false, #keep folder structure when compiling
      cwd: app_folder,
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
  jade_files[ jade_output ] =["#{app_folder}/**/*.jade"]
  config.jade2js =
    compile:
      options:
        namespace: "JST"
      files: jade_files


  # Mobile deployment
  cordova_root = "yonti"
  cordova_www = "#{cordova_root}/www/"

  config.copy =
    cordova:
      files:[
        {expand: true, src: "build/**/*", dest: "#{cordova_www}"}
        {expand: true, src: "bower_components/ratchet/dist/css/ratchet.css",
        dest: "#{cordova_www}"}
        {expand: true, src: "bower_components/ratchet/dist/js/ratchet.js",
        dest: "#{cordova_www}"}
        {expand: true, src: "node_modules/swiper/dist/css/swiper.min.css",
        dest: "#{cordova_www}"}
        {expand: true, src: "index.html", dest: "#{cordova_www}"}
      ]

  command_in_root = (command)->
    command: command
    options:
      execOptions:
        cwd: cordova_root

  platform_configuration = (platform_name)->
    result = {}
    result["build_#{platform_name}"] =
      command_in_root("cordova build #{platform_name}")
    result["platforms_#{platform_name}"] =
      command_in_root("cordova platform add #{platform_name}")
    result["emulate_#{platform_name}"] =
      command_in_root("cordova emulate #{platform_name}")
    result

  mobile_shell_config = {}
  mobile_shell_config.create =
    command: [ "rm -rf #{cordova_root}",
    "cordova create #{cordova_root} com.nirnaor.yonti YontiMemory" ].join "&&"

  _(mobile_shell_config).extend(platform_configuration("ios"))
  _(mobile_shell_config).extend(platform_configuration("android"))
  config.shell = mobile_shell_config


        



  grunt.initConfig config
  grunt.registerTask("code", [ "coffee", "browserify" ])
  grunt.registerTask("templates", [ "jade2js" ])
  grunt.registerTask("default", ["code", "templates"])


  grunt.registerTask("mobile_base", ["shell:create","copy:cordova" ])

  grunt.registerTask("build_ios", ["mobile_base", "shell:platforms_ios",
  "shell:build_ios", "shell:emulate_ios"])
  grunt.registerTask("build_android", ["mobile_base",
  "shell:platforms_android", "shell:build_android", "shell:emulate_android"])
 

 


