import UIKit

extension UIView {
    func bounceOut(duration: Double) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .beginFromCurrentState, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.0001, y: 0.0001)
        }, completion: nil)
    }
}

let viewFrame: CGRect = CGRect(x: 100, y: 100, width: 10, height: 10)
let view: UIView = UIView(frame: viewFrame)
view.backgroundColor = .green
view.bounds = CGRect(x: 0, y: 0, width: 300, height: 300)
print(view.frame.width, view.frame.height)
view.bounceOut(duration: 2)
print(view.frame.width, view.frame.height)

extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in Range(1...self) {
            closure()
        }
    }
}

5.times { print("Hello!") }

extension Array where Element: Comparable{
    mutating func remove(item: Element) {
        if let location = self.firstIndex(of: item) {
            self.remove(at: location)
        }
    }
}

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
