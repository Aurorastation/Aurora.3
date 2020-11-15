const arraySum = (arrA, arrB) => Array.prototype.map((v, i) => v + arrB[i], arrA)

export default {
  add(...arrays) {
    return arrays.reduce(arraySum)
  },
  multiply(arrA, arrB) {
    return Array.prototype.map((v, i) => v * arrB[i], arrA)
  },
  scale(arrA, factor) {
    return Array.prototype.map((v) => v * factor, arrA)
  }
}