//
//  DataServiceA.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/6/3.
//

import Foundation
import RxRelay
import RxSwift

protocol DataServiceARequestProtocol: AutoMockable {
    func fetchData() -> Single<[DataServiceA.RawModel]>
}

struct DataServiceARequest: DataServiceARequestProtocol {
    func fetchData() -> Single<[DataServiceA.RawModel]> {
        return Single<[DataServiceA.RawModel]>.create { observer in
            let response = [
                DataServiceA.RawModel(title: "one", sourceNumStr: "1"),
                DataServiceA.RawModel(title: "two", sourceNumStr: "3"),
                DataServiceA.RawModel(title: "one", sourceNumStr: "7"),
                DataServiceA.RawModel(title: "three", sourceNumStr: "1"),
                DataServiceA.RawModel(title: "one", sourceNumStr: "2"),
                DataServiceA.RawModel(title: "three", sourceNumStr: "1"),
                DataServiceA.RawModel(title: "two", sourceNumStr: "10"),
            ]
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                observer(.success(response))
            }
            return Disposables.create()
        }
    }
}

// Public protocol.
protocol DataServiceAProtocol: DataServiceStateProtocol, AutoMockable {
    // Trigger
    func fetchData(contextA: String?, contextB: Int?)
    
    // Used for pipe conbination.
    var outputDataStream: Observable<DataServiceA.OutputData?> { get }
}

extension DataServiceA {
    struct RawModel: Equatable, AutoDummyFactoryGeneratable {
        let title: String
        let sourceNumStr: String
    }
    
    struct Context: AutoDummyFactoryGeneratable {
        let contextA: String?
        let contextB: Int?
    }
    
    struct OutputData: AutoDummyFactoryGeneratable {
        let data: [DataServiceA.RawModel]
        let context: DataServiceA.Context?
    }
}

extension DataServiceA: DataServiceAProtocol {
    var outputDataStream: Observable<DataServiceA.OutputData?> {
        return dataSubject.asObservable()
    }
    
    var stateStream: Observable<DataServiceState> {
        return stateSubject.asObservable()
    }
    
    func fetchData(contextA: String?, contextB: Int?) {
        stateSubject.accept(.loading)
        request.fetchData().subscribe(onSuccess: { [weak self] (data) in
            self?.stateSubject.accept(.success)
            self?.dataSubject.accept(DataServiceA.OutputData(data: data, context: Context(contextA: contextA, contextB: contextB)))
        }, onError: { [weak self] (error) in
            self?.stateSubject.accept(.error(error))
        }).disposed(by: disposeBag)
    }
}

final class DataServiceA {
    let dataSubject: BehaviorRelay<DataServiceA.OutputData?> = BehaviorRelay(value: nil)
    let stateSubject: BehaviorRelay<DataServiceState> = BehaviorRelay(value: .none)
    let request: DataServiceARequestProtocol
    let disposeBag = DisposeBag()
    
    init(request: DataServiceARequestProtocol = DataServiceARequest()) {
        self.request = request
    }
}
