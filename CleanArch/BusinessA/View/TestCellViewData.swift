//
//  TestCellViewData.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/6/1.
//

import Foundation

struct TestCellViewData {
    struct Data: Equatable {
        let title: String
        let info: String
    }
    
    static func config(cell: TestCell, data: Data) {
        cell.titleLabel.text = data.title
        cell.infoLabel.text = data.info
    }
    
    static func config(cell: TestCell, title: String, info: String) {
        cell.titleLabel.text = title
        cell.infoLabel.text = info
    }
}
