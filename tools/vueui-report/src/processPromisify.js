const child_process = require('child_process')

module.exports = {
  exec(command, options = {}) {
    return new Promise((resolve, reject) => {
      child_process.exec(command, options, (error, stdout, stderr) => {
        if (error) {
          reject({ error, stdout, stderr })
          return
        }
        resolve({ stdout, stderr })
      })
    })
  },
}
