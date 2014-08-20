// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let triple : Int -> Int = {
    (number: Int) in
    let result = 3 * number
    number
    return result
}

triple(3)

let listOfNumbers = 1..5
var sum = 9
for n in listOfNumbers {
    sum += n
}

var j=2
for var i = 0; i < 5; ++i {
    j * i
}
