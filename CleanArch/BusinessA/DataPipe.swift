//
//  DataPipe.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/6/3.
//

import Foundation
import RxSwift

// Public protocol.
protocol MyDataPipeProtocol {
    func setup(presenter: MyPresenterProtocol)
}

// Data pipe for shared service A.
extension DataServiceA: MyDataPipeProtocol {
    func setup(presenter: MyPresenterProtocol) {
        outputDataStream
            .map(convert)
            .bind(to: presenter.inputDataStream)
            .disposed(by: disposeBag)
    }
    
    func convert(serviceData: DataServiceA.OutputData?) -> MyPresenter.InputData? {
        if let serviceData = serviceData {
            print("Context: \(String(describing: serviceData.context))")
            let inputData = serviceData.data.map({ MyPresenter.InputItem(title: $0.title, sourceInt: Int($0.sourceNumStr) ?? -1) })
            return MyPresenter.InputData(data: inputData)
        }
        return nil
    }
}

// Data pipe for combined service.
extension MyDataService: MyDataPipeProtocol {
    func setup(presenter: MyPresenterProtocol) {
        outputDataStream
            .map(convert)
            .bind(to: presenter.inputDataStream)
            .disposed(by: disposeBag)
    }
    
    func convert(serviceData: MyDataService.OutputData?) -> MyPresenter.InputData? {
        if let serviceData = serviceData {
            print("Context: \(String(describing: serviceData.context))")
            var list: [MyPresenter.InputItem] = []
            for (idx, title) in serviceData.data.enumerated() {
                let source = serviceData.sourceNumStr[idx]
                list.append(MyPresenter.InputItem(title: title, sourceInt: Int(source) ?? -1))
            }
            return MyPresenter.InputData(data: list)
        }
        return nil
    }
}
