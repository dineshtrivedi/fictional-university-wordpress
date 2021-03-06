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

  // Browsersync only works if there is only one body tag
  // INCLUDING comments - https://github.com/BrowserSync/browser-sync/issues/1065#issuecomment-254180616
  // No body tag also does not work.
  browserSync.init({
    notify: false,
    proxy: settings.urlToPreview,
    ghostMode: false
  });

  gulp.watch(settings.themeLocation + '../../**/*.php', (done) => {
    console.log('Php file has changed in wp-content folder');
    browserSync.reload();
    done();
  });

  gulp.watch(settings.themeLocation + 'css/**/*.css', gulp.parallel('waitForStyles'));

  gulp.watch([settings.themeLocation + 'js/modules/*.js', settings.themeLocation + 'js/scripts.js'], gulp.parallel('waitForScripts'));

});

gulp.task('waitForStyles', gulp.series('styles', () => {
  return gulp.src(settings.themeLocation + 'style.css')
    .pipe(browserSync.stream());
}));

gulp.task('waitForScripts', gulp.series('scripts', (done) => {
  browserSync.reload();
  done()
}));

gulp.task("clean", () => {
  return del([settings.themeLocation + 'style.css', settings.themeLocation + "js/scripts-bundled.js"]);
});

gulp.task("build", gulp.series(
    'clean',
    gulp.parallel('styles', 'scripts')
  )
);