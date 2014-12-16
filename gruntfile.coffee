
module.exports = (grunt) ->
    coffeeConfig = {
        compile:
          files: { 
            "fake_titan.js": ["coffee/fake_titan.coffee"]
            "js/app.js" : ["coffee/app.coffee"]
            "js/directives.js" : ["coffee/directives.coffee"]
            "js/minioncontroller.js" : ["coffee/minioncontroller.coffee"]
          }, 
          options:
            sourceMap: false
            bare: false
    }

    bowerConfig = {
        install:
            options:
                targetDir: "./build/www/pages/kncminion/lib"
                cleanTargetDir: true
                layout : "byType"
    }

    copyConfig = {
        main:
            files: [
                { expand: true, cwd: 'html/', src: [ '**'], dest: 'build/www/pages/kncminion/'}
                { expand: true, cwd: 'images/', src: [ '**'], dest: 'build/www/pages/kncminion/images'}
                { expand: true, src: ['js/**'], dest: 'build/www/pages/kncminion/' }
                { expand: true, cwd: 'scripts/cgi-bin/', src: [ '**'], dest: 'build/www/pages/cgi-bin' }
                { expand: false, src: 'scripts/runme.sh', dest: 'firmwarebuild/files/runme.sh' }
            ]
    }

    compressConfig = {
        www:
            options: 
                mode: 'tgz'
                archive: 'firmwarebuild/files/www.tgz'
            expand: true,
            cwd: 'build/'
            src: ['**/*']

        firmwarefile:
            options: 
                mode: 'tgz'
                archive: () -> 'firmwarebuild/kncminion-' + grunt.option('gitRevision') + '.bin'
            expand: true,
            cwd: 'firmwarebuild/files'
            src: ['**/*']
    }

    cleanConfig = [ 'build/**', 'firmwarebuild/**' ]

    gitDescribeConfig = {
        tagname:
            options:
                failOnError: false
                template: "-{%=tag%}-{%=object%}{%=dirty%}"
        
    }

    textReplaceCfg = {
        version: {
            src: ['build/www/pages/**/*.html']
            overwrite: true
            replacements: [{
                from: 'APPVERSION_HERE',
                to: () -> grunt.option('gitRevision')
            }]
        }
    }

    cfg = {
        coffee: coffeeConfig
        bower: bowerConfig
        copy: copyConfig
        compress: compressConfig
        clean: cleanConfig
        "git-describe": gitDescribeConfig
        replace: textReplaceCfg
    }

    grunt.initConfig(cfg)

    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-bower-task')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-compress')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-git-describe')
    grunt.loadNpmTasks('grunt-text-replace')

    grunt.registerTask('saveRevision', () ->
        grunt.event.once('git-describe', (rev) ->
            revision = "unknown"
            if rev.tag?
                revision = rev.tag
            else if rev.object?
                revision = rev.object
            
            if rev.dirty?
                revision += rev.dirty
            grunt.option('gitRevision', revision)
        )
    )


    taskList = ['clean','saveRevision', 'git-describe:tagname','coffee','bower','copy','replace:version', 'compress:www', 'compress:firmwarefile']
    grunt.registerTask('default', taskList)