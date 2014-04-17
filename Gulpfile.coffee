gulp = require('gulp')
watch = require('gulp-watch')
plumber = require('gulp-plumber')
browserify = require('gulp-browserify')
rename = require('gulp-rename')

gulp.task 'default', () ->

  watch { glob: 'js/**/*.coffee' }, () ->
    gulp.src(['js/designer.coffee'], { read: false })
      .pipe(plumber())
      .pipe(browserify({
        transform: ['coffeeify'],
        extensions: ['.coffee']
      }))
      .pipe(rename({
        dirname: "./",
        extname: ".js"
        }))
      .pipe(gulp.dest('./public/'))


