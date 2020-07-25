import UIKit

extension Double {
    func round(to places: Int) -> Double {
        let precisionNumber = pow(10, Double(places))
        var n = self * precisionNumber
        n.round()
        return n / precisionNumber
    }
}

var myDouble = 3.1415926

let myRoundedDouble = String(format: "%.1f", myDouble)

print(myRoundedDouble)

myDouble.round(to: 9)

let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
button.backgroundColor = .red

extension UIButton {
    func makeCircular() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

button.makeCircular()
