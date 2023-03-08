import child_process from 'child_process'

export function exec(
  command: string,
  options: child_process.ExecOptions = {}
): Promise<{ stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    child_process.exec(command, options, (error, stdout, stderr) => {
      if (error) {
        reject({ error, stdout, stderr })
        return
      }
      resolve({ stdout, stderr })
    })
  })
}

export default {
  exec,
}
