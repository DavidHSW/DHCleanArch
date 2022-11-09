// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
@testable import CleanArch
import CoreLocation
import AVFoundation

extension DataServiceA.Context {
    static func dummy(contextA: String? = nil, contextB: Int? = nil) -> DataServiceA.Context {
        return self.init(contextA: contextA, contextB: contextB)
    }
}
extension DataServiceA.OutputData {
    static func dummy(data: [DataServiceA.RawModel] = [], context: DataServiceA.Context? = nil) -> DataServiceA.OutputData {
        return self.init(data: data, context: context)
    }
}
extension DataServiceA.RawModel {
    static func dummy(title: String = "", sourceNumStr: String = "") -> DataServiceA.RawModel {
        return self.init(title: title, sourceNumStr: sourceNumStr)
    }
}
extension DataServiceB.OutputData {
    static func dummy(isChinese: Bool = false, context: String? = nil) -> DataServiceB.OutputData {
        return self.init(isChinese: isChinese, context: context)
    }
}
extension MyDataService.OutputData {
    static func dummy(data: [String] = [], sourceNumStr: [String] = [], context: String? = nil) -> MyDataService.OutputData {
        return self.init(data: data, sourceNumStr: sourceNumStr, context: context)
    }
}
extension MyPresenter.InputData {
    static func dummy(data: [MyPresenter.InputItem] = []) -> MyPresenter.InputData {
        return self.init(data: data)
    }
}
extension MyPresenter.InputItem {
    static func dummy(title: String = "", sourceInt: Int = 0) -> MyPresenter.InputItem {
        return self.init(title: title, sourceInt: sourceInt)
    }
}
extension MyPresenter.OutputData {
    static func dummy(data: [TestCellViewData.Data] = []) -> MyPresenter.OutputData {
        return self.init(data: data)
    }
}
