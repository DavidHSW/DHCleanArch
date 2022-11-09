//
//  DataService.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/5/30.
//

import Foundation
import RxSwift
import RxRelay

// Public protocol.
protocol MyDataServiceProtocol: DataServiceStateProtocol, AutoMockable {
    func fetchData(context: String?)
    
    // Standard Output. Used for pipe conbination.
    var outputDataStream: Observable<MyDataService.OutputData?> { get }
}

extension MyDataService {
    struct OutputData: AutoDummyFactoryGeneratable {
        let data: [String]
        let sourceNumStr: [String]
        let context: String?
    }
}

extension MyDataService: MyDataServiceProtocol {
    var outputDataStream: Observable<MyDataService.OutputData?> {
        return dataSubject.asObservable()
    }
    
    var stateStream: Observable<DataServiceState> {
        return stateSubject.asObservable()
    }
    
    func fetchData(context: String?) {
        dataServiceA.fetchData(contextA: "contextA from my service", contextB: 999)
        dataServiceB.fetchData(contextC: "contextC from my service")
        self.context = context
    }
}

final class MyDataService {
    private let dataServiceA: DataServiceAProtocol
    private let dataServiceB: DataServiceBProtocol
    private let stateSubject: BehaviorRelay<DataServiceState> = BehaviorRelay(value: .none)
    private let dataSubject: BehaviorRelay<OutputData?> = BehaviorRelay(value: nil)
    private var context: String?
    let disposeBag = DisposeBag()
    
    init(dataServiceA: DataServiceAProtocol = DataServiceA(),
         dataServiceB: DataServiceBProtocol = DataServiceB()) {
        self.dataServiceA = dataServiceA
        self.dataServiceB = dataServiceB
        
        // Combine state
        Observable.combineLatest(dataServiceA.stateStream, dataServiceB.stateStream)
            .map({ stateA, stateB -> DataServiceState in
                switch (stateA, stateB) {
                case (.loading, .loading),
                     (.loading, .success),
                     (.success, .loading),
                     (.loading, .none),
                     (.none, .loading):
                    return .loading
                case (_, .error),
                     (.error, _):
                    return .error(NSError())
                case (.success, .success):
                    return .success
                default:
                    return .none
                }
            })
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
        
        // Combine data
        Observable.combineLatest(dataServiceA.outputDataStream, dataServiceB.outputDataStream)
            .map({ [weak self] dataA, dataB -> OutputData? in
                guard let self = self, let dataA = dataA, let dataB = dataB else { return nil }
                let data = dataA.data.map({ item -> String in
                    if dataB.isChinese {
                        if item.title == "one" {
                            return "一"
                        } else if item.title == "two" {
                            return "二"
                        } else {
                            return "三"
                        }
                    } else {
                        return item.title
                    }
                })
                let source = dataA.data.map({ $0.sourceNumStr })
                let contextA = (dataA.context?.contextA ?? "") + " | " + "\(dataA.context?.contextB ?? -999)" + " | "
                let contextB = contextA + (dataB.context ?? "") + " | "
                let context = contextB + (self.context ?? "")
                return OutputData(data: data, sourceNumStr: source, context: context)
            })
            .bind(to: dataSubject)
            .disposed(by: disposeBag)
        
        // If error, reset UI.
        stateSubject.subscribe(onNext: { [weak self] (state) in
            guard let self = self else { return }
            if let _ = state.error {
                self.dataSubject.accept(self.dataSubject.value)
            }
        }).disposed(by: disposeBag)
    }
}
