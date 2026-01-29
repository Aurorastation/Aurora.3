/**
 * @file
 * @copyright 2021 AnturK https://github.com/AnturK
 * @license MIT
 */

// Change working directory to project root
process.chdir(__dirname);

// Silently make a dist folder
try {
  require('node:fs').mkdirSync('dist');
} catch (err) {}
