//
//  SharedBusinessB.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/5/30.
//

import Foundation

struct SharedBusinessB {
    static func convertNumber(num: Int) -> String {
        if num == 1 {
            return "from source: 1"
        } else if num == 2 {
            return "from source: 2"
        } else {
            return "\(num)"
        }
    }
}
