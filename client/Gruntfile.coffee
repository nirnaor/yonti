_ = require "underscore"
module.exports = (grunt)->
  for task in [ 'grunt-contrib-coffee' , 'grunt-browserify',
  'grunt-contrib-watch', 'grunt-jade-plugin', 'grunt-contrib-copy',
  'grunt-shell', 'grunt-contrib-compass' ]
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
    style:
      files: "#{app_folder}/**/*.scss"
      tasks: [ "style" ]
      options: livereload: 35729

  

  build_folder = "build"
  files_build_folder = "build/files"
  coffee_output = "#{build_folder}/coffee_output"
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
      dest: "#{files_build_folder}/browserified.js"



  # Templates
  jade_files= {}
  jade_output  = "#{files_build_folder}/templates.js"
  jade_files[ jade_output ] =["#{app_folder}/**/*.jade"]
  config.jade2js =
    compile:
      options:
        namespace: "JST"
      files: jade_files

  # Style
  config.compass =
    dist:
      options:
        sassDir: app_folder
        cssDir: files_build_folder


  # Mobile deployment
  cordova_root = "yonti"
  cordova_www = "#{cordova_root}/www/"

  files_to = (folder)->
    files_folder ="#{folder}/files"
    files:[
      # {expand: true, src: "#{coffee_output}/**/*", dest: "#{files_folder}"}
      {expand: true, src: "bower_components/ratchet/dist/css/ratchet.css",
      dest: "#{files_folder}"}
      {expand: true, src: "bower_components/ratchet/dist/fonts/*",
      dest: "#{files_folder}"}
      {expand: true, src: "bower_components/ratchet/dist/js/ratchet.js",
      dest: "#{files_folder}"}
      {expand: true, src: "node_modules/swiper/dist/css/swiper.min.css",
      dest: "#{files_folder}"}
      {expand: true, src: "bower_components/tabletop/src/tabletop.js",
      dest: "#{files_folder}"}
      {expand: true, src: "index.html", dest: "#{folder}"}
    ]

  config.copy =
    build: files_to(build_folder)
    cordova: files: [
      { src: [ '**' ], dest: cordova_www, cwd: build_folder, expand: true},
      { src: "config.xml", dest: "#{cordova_root}/"}
    ]

  command_in_root = (command)->
    command: command
    options:
      execOptions:
        cwd: cordova_root

  platform_configuration = (platform_name)->
    result = {}
    result["build_#{platform_name}"] =
      command_in_root("cordova build #{platform_name} --release")
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
  config.shell.clean_coffee = command: "rm -rf #{coffee_output}"


        



  grunt.initConfig config
  grunt.registerTask("code", [ "coffee", "browserify", "shell:clean_coffee"])

  grunt.registerTask("templates", [ "jade2js" ])
  grunt.registerTask("style", [ "compass" ])
  grunt.registerTask("default", ["code", "templates", "style", "copy:build"])


  grunt.registerTask("mobile_base", [ "default", "shell:create", "copy:cordova" ])

  grunt.registerTask("build_ios", ["mobile_base", "shell:platforms_ios"
  "shell:build_ios", "shell:emulate_ios"])
  grunt.registerTask("build_android", ["mobile_base",
  "shell:platforms_android", "shell:build_android", "shell:emulate_android"])
 

 


