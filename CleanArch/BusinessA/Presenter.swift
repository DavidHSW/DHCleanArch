//
//  Presenter.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/5/30.
//

import Foundation
import RxSwift
import RxRelay

// Public protocol.
protocol MyPresenterProtocol {
    // Standard Output
    var outputDataStream: BehaviorRelay<MyPresenter.OutputData?> { get }
    // Standard Input. Used for pipe conbination.
    var inputDataStream: BehaviorRelay<MyPresenter.InputData?> { get }
    
    // Util
    var numberOfRow: Int { get }
    func viewData(at indexPath: IndexPath) -> TestCellViewData.Data
}

extension MyPresenter {
    struct InputItem: AutoDummyFactoryGeneratable {
        let title: String
        let sourceInt: Int
    }
    
    struct InputData: AutoDummyFactoryGeneratable {
        let data: [MyPresenter.InputItem]
    }
    
    struct OutputData: AutoDummyFactoryGeneratable {
        let data: [TestCellViewData.Data]
    }
}

extension MyPresenter: MyPresenterProtocol {
    var inputDataStream: BehaviorRelay<MyPresenter.InputData?> {
        return inputDataSubject
    }
    
    var outputDataStream: BehaviorRelay<MyPresenter.OutputData?> {
        return outputDataSubject
    }
    
    var numberOfRow: Int {
        return outputDataSubject.value?.data.count ?? 0
    }
    
    func viewData(at indexPath: IndexPath) -> TestCellViewData.Data {
        return outputDataSubject.value?.data[indexPath.row] ?? TestCellViewData.Data(title: "", info: "")
    }
}

final class MyPresenter {
    let inputDataSubject: BehaviorRelay<MyPresenter.InputData?> = BehaviorRelay(value: nil)
    let outputDataSubject: BehaviorRelay<MyPresenter.OutputData?> = BehaviorRelay(value: nil)
    let disposeBag = DisposeBag()

    init() {
        inputDataSubject.map(convert).bind(to: outputDataSubject).disposed(by: disposeBag)
    }
    
    func convert(inputData: MyPresenter.InputData?) -> MyPresenter.OutputData? {
        if let inputData = inputData {
            return MyPresenter.OutputData(data: inputData.data.map({ data -> TestCellViewData.Data in
                let title = SharedBusinessA.convertString(numStr: data.title) + "->" +  "[\(SharedBusinessB.convertNumber(num: data.sourceInt))]"
                let info = data.sourceInt%2 == 0 ? "even source" : "odd source"
                return TestCellViewData.Data(title: title, info: info)
            }))
        }
        return nil
    }
}
