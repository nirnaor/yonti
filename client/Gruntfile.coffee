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
  cordova_platforms = "#{cordova_root}/platforms"
  android_folder = "#{cordova_platforms}/android"
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
      {expand: true, src: "index.html", dest: "#{folder}"},
      {expand: true, src: "app/IcoMoonFonts/**/*", dest: "#{folder}"}
    ]

  config.copy =
    android_manifest:
      src: "AndroidManifest.xml", dest: "#{android_folder}/AndroidManifest.xml"
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
  config.shell.deploy_web = command: "scp -r #{build_folder} root@192.241.186.177:/home/"

  source_apk = "ant-build/MainActivity-release-unsigned.apk"
  zipalign_location = "~/Library/Android/sdk/build-tools/21.1.2/zipalign"
  alias_name = "yonti"
  output_apk = "yonti.apk"

  config.shell.copy_android_manifest =
    command: "cp AndroidManifest.xml #{android_folder}"
      

  config.shell.deploy_android =
    command: [
      "keytool -genkey -v -keystore my-release-key.keystore -alias #{alias_name} -keyalg RSA -keysize 2048 -validity 10000",
      "jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore my-release-key.keystore #{source_apk} #{alias_name}",
      "#{zipalign_location} -v 4 #{source_apk} #{output_apk}",
      "echo file is ready for deployment at #{android_folder}/#{output_apk}",
    ].join('&&')
    options:
      execOptions:
        cwd: android_folder


        



  grunt.initConfig config
  grunt.registerTask("code", [ "coffee", "browserify", "shell:clean_coffee"])

  grunt.registerTask("templates", [ "jade2js" ])
  grunt.registerTask("style", [ "compass" ])
  grunt.registerTask("default", ["code", "templates", "style", "copy:build"])


  grunt.registerTask("mobile_base", [ "default", "shell:create", "copy:cordova" ])

  grunt.registerTask("build_ios", ["mobile_base", "shell:platforms_ios"
  "shell:build_ios", "shell:emulate_ios"])
  grunt.registerTask("build_android", ["mobile_base",
  "shell:platforms_android","copy:android_manifest",  "shell:build_android",
  "shell:emulate_android"])
  grunt.registerTask("deploy_web", ["default", "shell:deploy_web" ])
  grunt.registerTask("deploy_android", [ "shell:deploy_android" ])
 

 


