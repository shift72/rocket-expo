const { withAppBuildGradle } = require('expo/config-plugins');

// From this discussion in gethub https://github.com/expo/expo/discussions/31071#discussioncomment-11128404

module.exports = function addDesugaringForRocket(config) {
 return withAppBuildGradle(config, async (config) => {
   const androidPattern = '\nandroid {\n';
   const androidIndex = config.modResults.contents.indexOf(androidPattern);
   const androidPivot = androidIndex + androidPattern.length + 1;
   config.modResults.contents =
     config.modResults.contents.slice(0, androidPivot) +
     '   compileOptions {\n        coreLibraryDesugaringEnabled true\n    }\n\n ' +
     config.modResults.contents.slice(androidPivot);

   const dependenciesPattern = '\ndependencies {\n';
   const dependenciesIndex = config.modResults.contents.indexOf(dependenciesPattern);
   const dependenciesPivot = dependenciesIndex + dependenciesPattern.length + 1;
   config.modResults.contents =
     config.modResults.contents.slice(0, dependenciesPivot) +
     '   coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")\n\n ' +
     config.modResults.contents.slice(dependenciesPivot);

   return config;
 });
};