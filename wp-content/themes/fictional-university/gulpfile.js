const gulp = require('gulp'),
settings = require('./settings'),
webpack = require('webpack'),
browserSync = require('browser-sync').create(),
postcss = require('gulp-postcss'),
rgba = require('postcss-hexrgba'),
autoprefixer = require('autoprefixer'),
cssvars = require('postcss-simple-vars'),
nested = require('postcss-nested'),
cssImport = require('postcss-import'),
mixins = require('postcss-mixins'),
colorFunctions = require('postcss-color-function'),
del = require("del");

gulp.task('styles', () => {
  return gulp.src(settings.themeLocation + 'css/style.css')
    .pipe(postcss([cssImport, mixins, cssvars, nested, rgba, colorFunctions, autoprefixer]))
    .on('error', (error) => console.log(error.toString()))
    .pipe(gulp.dest(settings.themeLocation));
});

gulp.task('scripts', (callback) => {
  webpack(require('./webpack.config.js'), (err, stats) => {
    if (err) {
      console.log(err.toString());
    }

    console.log(stats.toString());
    callback();
  });
});

gulp.task('watch', () => {

  browserSync.init({
    notify: false,
    proxy: settings.urlToPreview,
    ghostMode: false
  });

  gulp.watch(settings.themeLocation + '**/*.php', () => {
    browserSync.reload();
  });

  gulp.watch(settings.themeLocation + 'css/**/*.css', gulp.parallel('waitForStyles'));

  gulp.watch([settings.themeLocation + 'js/modules/*.js', settings.themeLocation + 'js/scripts.js'], gulp.parallel('waitForScripts'));

});

gulp.task('waitForStyles', gulp.series('styles', () => {
  return gulp.src(settings.themeLocation + 'style.css')
    .pipe(browserSync.stream());
}));

gulp.task('waitForScripts', gulp.series('scripts', (cb) => {
  browserSync.reload();
  cb()
}));

gulp.task("clean", () => {
  return del([settings.themeLocation + 'style.css', settings.themeLocation + "js/scripts-bundled.js"]);
});

gulp.task("build", gulp.series(
    'clean',
    gulp.parallel('styles', 'scripts')
  )
);