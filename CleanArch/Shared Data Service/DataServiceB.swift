//
//  DataServiceB.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/6/3.
//

import Foundation
import RxRelay
import RxSwift

protocol DataServiceBRequestProtocol: AutoMockable {
    func fetchData() -> Single<Bool>
}

struct DataServiceBRequest: DataServiceBRequestProtocol {
    func fetchData() -> Single<Bool> {
        return Single<Bool>.create { observer in
            let response = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                observer(.success(response))
            }
            return Disposables.create()
        }
    }
}

// Public protocol.
protocol DataServiceBProtocol: DataServiceStateProtocol, AutoMockable {
    // Trigger
    func fetchData(contextC: String?)
    
    // Used for pipe conbination.
    var outputDataStream: Observable<DataServiceB.OutputData?> { get }
}

extension DataServiceB {
    struct OutputData: AutoDummyFactoryGeneratable {
        let isChinese: Bool
        let context: String?
    }
}

extension DataServiceB: DataServiceBProtocol {
    var outputDataStream: Observable<DataServiceB.OutputData?> {
        return dataSubject.asObservable()
    }
    
    var stateStream: Observable<DataServiceState> {
        return stateSubject.asObservable()
    }
    
    func fetchData(contextC: String?) {
        stateSubject.accept(.loading)
        request.fetchData().subscribe(onSuccess: { [weak self] (data) in
            self?.stateSubject.accept(.success)
            self?.dataSubject.accept(DataServiceB.OutputData(isChinese: data, context: contextC))
        }, onError: { [weak self] error in
            self?.stateSubject.accept(.error(error))
        }).disposed(by: disposeBag)
    }
}

final class DataServiceB {
    let dataSubject: BehaviorRelay<DataServiceB.OutputData?> = BehaviorRelay(value: nil)
    let stateSubject: BehaviorRelay<DataServiceState> = BehaviorRelay(value: .none)
    let request: DataServiceBRequestProtocol
    let disposeBag = DisposeBag()
    
    init(request: DataServiceBRequestProtocol = DataServiceBRequest()) {
        self.request = request
    }
}
