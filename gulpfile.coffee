gulp = require('gulp')
nodemon = require('gulp-nodemon')
livereload = require('gulp-livereload')
less = require('gulp-less')
wiredep = require('wiredep')
useref = require('gulp-useref')
jade = require('gulp-jade')
coffee = require('gulp-coffee')
shell = require('gulp-shell')


frontendPaths = {
  less: './app/less/*.less'
  coffee: ["app/**/*.coffee"]
  jade: ['app/**/*.jade']
}

gulp.task 'jade', ['wiredep'], ->
  gulp.src(frontendPaths.jade).pipe(jade())
  .pipe(gulp.dest('./public'))

gulp.task 'wiredep', ->
  wiredep({
    src: 'app/index.jade',
    directory: 'app/components',
  })

gulp.task 'less', ->
  gulp.src(frontendPaths.less)
    .pipe(less())
    .pipe(gulp.dest('./public/css'))
    .pipe(livereload())

# if use coffee i think that jshint is useless, is it true ?
#jshint = require('gulp-jshint')
#gulp.task 'hint', ->
#  return gulp.src(frontendPaths.js).pipe(jshint())

gulp.task "coffee", (done) ->
  gulp.src(frontendPaths.coffee).pipe(coffee(bare: true)).pipe(gulp.dest("./public/js/")).on "end", done
  return


# frontend watch andviews livereload
gulp.task 'watch', ->
  gulp.watch(frontendPaths.less, ['less'])
  gulp.watch(frontendPaths.jade, ['jade'])
  # when jade file changed, only recompile the one file, so not use the jade task
  gulp.watch(frontendPaths.jade).on "change", (e) ->
    gulp.src(e.path).pipe(jade().on("error", (err) ->
      console.log err
      return
    )).pipe(gulp.dest('./public')).pipe(livereload())
    return

  # when coffee file changed, only recompile the one file, so not use the coffee task
  gulp.watch(frontendPaths.coffee).on "change", (e) ->
    #console.log e.path
    dest = e.path.replace /\/[^\/]+$/, ''
    destpath = dest.replace /\/.+?app/, ''
    gulp.src(e.path).pipe(coffee(bare: true).on("error", (err) ->
      console.log err
      return
    )).pipe(gulp.dest('./public/js' + destpath)).pipe(livereload())
    return
  return

# serverend watch and livereload
gulp.task 'develop', ->
  shell([__dirname + '/bin/kill_dev_process'])
  livereload.listen()
  nodemon({
    script: 'server/app.coffee'
    watch: 'server'
    ext: 'coffee'
    # coffee files in public and app dir is for frontend, leave them to watch task
    #ignore: ['./app/**/*.coffee']
  }).on('restart', ->
    setTimeout(->
      livereload.changed(__dirname)
    , 2000)
  )

gulp.task 'default', [
  'jade'
  'coffee'
  'less'
  'develop'
  'watch'
]

# todo minify and uglify html css and js in this task
gulp.task 'dist', ->
  assets = useref.assets()
  gulp.src('public/index.html')
  .pipe(assets)
  .pipe(assets.restore())
  .pipe(useref())
  .pipe(gulp.dest('public'))
