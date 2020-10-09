import UIKit

extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.contains(prefix) { return self } else { return prefix + self}
    }
    
    func isNumeric() -> Bool{
        if Double(self) == nil { return false } else { return true }
    }
    
    var lines: [String.SubSequence] { self.split(separator: "\n") }
}

"pet".withPrefix("car")

"str".isNumeric()
"123".isNumeric()

"this\nis\na\ntest".lines
