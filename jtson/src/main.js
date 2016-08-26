var uint8 = new Uint8Array([1,2,3]);

console.log(typeof uint8)
console.log(Object.prototype.toString.apply(uint8))

console.log(uint8)

var s = uint8.slice(1);
console.log(s)
s[0] = 0;

console.log(uint8)
console.log(s)