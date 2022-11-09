//
//  SharedBusinessA.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/5/30.
//

import Foundation

struct SharedBusinessA {
    static func convertString(numStr: String) -> String {
        if numStr == "one" {
            return "one: 1"
        } else if numStr == "two" {
            return "two: 2"
        } else {
            return numStr
        }
    }
}
