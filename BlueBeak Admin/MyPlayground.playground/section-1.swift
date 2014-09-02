// Playground - noun: a place where people can play

import UIKit

var str = "Hello, CampIO"

let triple : Int -> Int = {
    (number: Int) in
    let result = 3 * number
    number
    return result
}

triple(7)

var j=2
var k = 0
for var i = 0; i < 5; ++i {
    k += j * i
}
k

let testLabel = UILabel(frame : CGRectMake(0, 0, 160, 40))
testLabel.text = "Hello, CampIO"
testLabel.backgroundColor = UIColor(red: 0.9, green: 0.7, blue : 0.2, alpha : 1.0)
testLabel.textAlignment = NSTextAlignment.Center
testLabel
