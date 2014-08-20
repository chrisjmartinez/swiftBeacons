// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let triple : Int -> Int = {
    (number: Int) in
    let result = 3 * number
    number
    return result
}

triple(4)

var j=2
for var i = 0; i < 5; ++i {
    j * i
}

let testLabel = UILabel(frame : CGRectMake(0, 0, 120, 40))
testLabel.text = "Hello, CampIO"
testLabel.backgroundColor = UIColor(red: 0.9, green: 0.2, blue : 0.2, alpha : 1.0)
testLabel