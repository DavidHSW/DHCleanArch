// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
@testable import CleanArch
import RxSwift
import RxRelay
import WebKit
import AVKit
import CoreLocation
import AVFoundation













class DataServiceAProtocolMock: DataServiceAProtocol {
    var outputDataStream: Observable<DataServiceA.OutputData?> {
        get { return underlyingOutputDataStream }
        set(value) { underlyingOutputDataStream = value }
    }
    var underlyingOutputDataStream: Observable<DataServiceA.OutputData?>!
    var stateStream: Observable<DataServiceState> {
        get { return underlyingStateStream }
        set(value) { underlyingStateStream = value }
    }
    var underlyingStateStream: Observable<DataServiceState>!

    // MARK: - fetchData

    var fetchDataContextAContextBCallsCount = 0
    var fetchDataContextAContextBCalled: Bool {
        return fetchDataContextAContextBCallsCount > 0
    }
    var fetchDataContextAContextBReceivedArguments: (contextA: String?, contextB: Int?)?
    var fetchDataContextAContextBClosure: ((String?, Int?) -> Void)?

    func fetchData(contextA: String?, contextB: Int?) {
        fetchDataContextAContextBCallsCount += 1
        fetchDataContextAContextBReceivedArguments = (contextA: contextA, contextB: contextB)
        fetchDataContextAContextBClosure?(contextA, contextB)
    }

}
class DataServiceARequestProtocolMock: DataServiceARequestProtocol {

    // MARK: - fetchData

    var fetchDataCallsCount = 0
    var fetchDataCalled: Bool {
        return fetchDataCallsCount > 0
    }
    var fetchDataReturnValue: Single<[DataServiceA.RawModel]>!
    var fetchDataClosure: (() -> Single<[DataServiceA.RawModel]>)?

    func fetchData() -> Single<[DataServiceA.RawModel]> {
        fetchDataCallsCount += 1
        return fetchDataClosure.map({ $0() }) ?? fetchDataReturnValue
    }

}
class DataServiceBProtocolMock: DataServiceBProtocol {
    var outputDataStream: Observable<DataServiceB.OutputData?> {
        get { return underlyingOutputDataStream }
        set(value) { underlyingOutputDataStream = value }
    }
    var underlyingOutputDataStream: Observable<DataServiceB.OutputData?>!
    var stateStream: Observable<DataServiceState> {
        get { return underlyingStateStream }
        set(value) { underlyingStateStream = value }
    }
    var underlyingStateStream: Observable<DataServiceState>!

    // MARK: - fetchData

    var fetchDataContextCCallsCount = 0
    var fetchDataContextCCalled: Bool {
        return fetchDataContextCCallsCount > 0
    }
    var fetchDataContextCReceivedContextC: String?
    var fetchDataContextCClosure: ((String?) -> Void)?

    func fetchData(contextC: String?) {
        fetchDataContextCCallsCount += 1
        fetchDataContextCReceivedContextC = contextC
        fetchDataContextCClosure?(contextC)
    }

}
class DataServiceBRequestProtocolMock: DataServiceBRequestProtocol {

    // MARK: - fetchData

    var fetchDataCallsCount = 0
    var fetchDataCalled: Bool {
        return fetchDataCallsCount > 0
    }
    var fetchDataReturnValue: Single<Bool>!
    var fetchDataClosure: (() -> Single<Bool>)?

    func fetchData() -> Single<Bool> {
        fetchDataCallsCount += 1
        return fetchDataClosure.map({ $0() }) ?? fetchDataReturnValue
    }

}
class MyDataServiceProtocolMock: MyDataServiceProtocol {
    var outputDataStream: Observable<MyDataService.OutputData?> {
        get { return underlyingOutputDataStream }
        set(value) { underlyingOutputDataStream = value }
    }
    var underlyingOutputDataStream: Observable<MyDataService.OutputData?>!
    var stateStream: Observable<DataServiceState> {
        get { return underlyingStateStream }
        set(value) { underlyingStateStream = value }
    }
    var underlyingStateStream: Observable<DataServiceState>!

    // MARK: - fetchData

    var fetchDataContextCallsCount = 0
    var fetchDataContextCalled: Bool {
        return fetchDataContextCallsCount > 0
    }
    var fetchDataContextReceivedContext: String?
    var fetchDataContextClosure: ((String?) -> Void)?

    func fetchData(context: String?) {
        fetchDataContextCallsCount += 1
        fetchDataContextReceivedContext = context
        fetchDataContextClosure?(context)
    }

}
