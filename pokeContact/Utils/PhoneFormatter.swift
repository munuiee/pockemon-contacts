// 전화번호 포맷터

import Foundation

enum PhoneFormatter {
    static func korean(_ s: String?) -> String {
        guard var n = s?.filter(\.isNumber), !n.isEmpty else { return "" }
        if n.hasPrefix("02") {
            if n.count >= 10 { return "02-\(n.dropFirst(2).prefix(4))-\(n.suffix(4))" }
            if n.count >= 9  { return "02-\(n.dropFirst(2).prefix(3))-\(n.suffix(4))" }
        } else if n.hasPrefix("010") {
            if n.count >= 11 { return "010-\(n.dropFirst(3).prefix(4))-\(n.suffix(4))" }
        } else {
            if n.count >= 10 { return "\(n.prefix(3))-\(n.dropFirst(3).prefix(4))-\(n.suffix(4))" }
        }
        return s ?? ""
    }
}

