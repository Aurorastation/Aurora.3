const arraySum = (arrA, arrB) => Array.prototype.map.call(arrA, (v, i) => v + arrB[i])

export default {
  add(...args) {
    return Array.prototype.reduce.call(args, arraySum)
  },
  multiply(arrA, arrB) {
    return Array.prototype.map.call(arrA, (v, i) => v * arrB[i])
  },
  scale(arrA, factor) {
    return Array.prototype.map.call(arrA, (v) => v * factor)
  }
}
