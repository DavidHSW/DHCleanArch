//
//  CleanArchTests.swift
//  CleanArchTests
//
//  Created by HU Siwei on 2020/6/8.
//

import XCTest
import RxSwift
import RxRelay
import RxBlocking
import RxTest
@testable import CleanArch

class CleanArchTests: XCTestCase {

    private var presenter: MyPresenterProtocol!

    private var dataService: MyDataServiceProtocol!
    private var dataServiceAMock: DataServiceAProtocolMock!
    private var dataServiceBMock: DataServiceBProtocolMock!
    
    private var dataServiceA: DataServiceAProtocol!
    private var dataServiceARequestMock: DataServiceARequestProtocolMock!
    private var stateAMock: BehaviorRelay<DataServiceState> = BehaviorRelay(value: .none)

    private var dataServiceB: DataServiceBProtocol!
    private var dataServiceBRequestMock: DataServiceBRequestProtocolMock!
    private var stateBMock: BehaviorRelay<DataServiceState> = BehaviorRelay(value: .none)

    private var scheduler: TestScheduler!
    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        presenter = MyPresenter()

        dataServiceAMock = DataServiceAProtocolMock()
        dataServiceBMock = DataServiceBProtocolMock()
        dataServiceAMock.underlyingStateStream = stateAMock.asObservable()
        dataServiceBMock.underlyingStateStream = stateBMock.asObservable()
        dataServiceAMock.underlyingOutputDataStream = Single.just(dummyDataServiceAOutput()).asObservable()
        dataServiceBMock.underlyingOutputDataStream = Single.just(dummyDataServiceBOutput()).asObservable()
        dataService = MyDataService(dataServiceA: dataServiceAMock, dataServiceB: dataServiceBMock)

        dataServiceARequestMock = DataServiceARequestProtocolMock()
        dataServiceA = DataServiceA(request: dataServiceARequestMock)
        
        dataServiceBRequestMock = DataServiceBRequestProtocolMock()
        dataServiceB = DataServiceB(request: dataServiceBRequestMock)
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        presenter = nil
        dataService = nil
        dataServiceAMock = nil
        dataServiceBMock = nil
        dataServiceA = nil
        dataServiceARequestMock = nil
        dataServiceB = nil
        dataServiceBRequestMock = nil
        scheduler = nil
        disposeBag = nil
        stateAMock = BehaviorRelay(value: .none)
        stateBMock = BehaviorRelay(value: .none)
        super.tearDown()
    }
    
    // data service A data
    func testDataServiceAOutput() {
        let expected = dummyDataServiceARequestResponse()
        dataServiceARequestMock.fetchDataReturnValue = dummyDataServiceARequest()
        dataServiceA.fetchData(contextA: "contextA", contextB: -999)
        if let model = try! dataServiceA.outputDataStream.skipWhile({ $0 == nil }).toBlocking(timeout: 3).first()! {
            XCTAssertTrue(model.data.elementsEqual(expected))
        } else {
            XCTAssert(false)
        }
    }
    
    // data service A state
    func testDataServiceAState() {
        dataServiceARequestMock.fetchDataReturnValue = dummyDataServiceARequest()
        let observable = scheduler.createObserver(Bool.self)
        scheduler.scheduleAt(0) {
            self.dataServiceA.stateStream.map({ $0.loading }).subscribe(observable).disposed(by: self.disposeBag)
        }
        scheduler.scheduleAt(100) {
            self.dataServiceA.fetchData(contextA: "contextA", contextB: -999)
        }
        scheduler.start()
        let expectedStream = [Recorded.next(0, false),
                              Recorded.next(100, true)]
        XCTAssertEqual(observable.events, expectedStream)
    }
    
    // data service B data
    func testDataServiceBOutput() {
        let expected = dummyDataServiceBRequestResponse()
        dataServiceBRequestMock.fetchDataReturnValue = dummyDataServiceBRequest()
        dataServiceB.fetchData(contextC: "contextB")
        if let model = try! dataServiceB.outputDataStream.skipWhile({ $0 == nil }).toBlocking(timeout: 3).first()! {
            XCTAssertEqual(model.isChinese, expected)
        } else {
            XCTAssert(false)
        }
    }
    
    // data service B state
    func testDataServiceBState() {
        dataServiceBRequestMock.fetchDataReturnValue = dummyDataServiceBRequest()
        let observable = scheduler.createObserver(Bool.self)
        scheduler.scheduleAt(0) {
            self.dataServiceB.stateStream.map({ $0.loading }).subscribe(observable).disposed(by: self.disposeBag)
        }
        scheduler.scheduleAt(100) {
            self.dataServiceB.fetchData(contextC: "context C")
        }
        scheduler.start()
        let expectedStream = [Recorded.next(0, false),
                              Recorded.next(100, true)]
        XCTAssertEqual(observable.events, expectedStream)
    }
    
    // data service data
    func testDataServiceOutput() {
        let expected = MyDataService.OutputData.dummy(data: ["三", "三", "三"], sourceNumStr: ["1", "2", "3"], context: nil)
        dataService.fetchData(context: "my context")
        if let model = try! dataService.outputDataStream.skipWhile({ $0 == nil }).toBlocking(timeout: 3).first()! {
            XCTAssertTrue(model.data.elementsEqual(expected.data))
            XCTAssertTrue(model.sourceNumStr.elementsEqual(expected.sourceNumStr))
        } else {
            XCTAssert(false)
        }
    }
    
    // data service state
    func testDataServiceState() {
        let observable = scheduler.createObserver(Bool.self)
        scheduler.scheduleAt(0) {
            self.dataService.stateStream.map({ $0.loading }).subscribe(observable).disposed(by: self.disposeBag)
        }
        scheduler.scheduleAt(100) {
            self.dataServiceAMock.fetchDataContextAContextBClosure = { [weak self] title, source in
                self?.stateAMock.accept(.loading)
            }
            // Or
            /*
            self.dataServiceBMock.fetchDataContextCClosure = { [weak self] title in
                self?.stateBMock.accept(.loading)
            }
            */
            self.dataService.fetchData(context: "my context")
        }
        scheduler.start()
        let expectedStream = [Recorded.next(0, false),
                              Recorded.next(100, true)]
        XCTAssertEqual(observable.events, expectedStream)
    }
    
    // presenter data
    func testPresenterOutput() {
        let input = MyPresenter.InputData(data: [
            MyPresenter.InputItem(title: "title1", sourceInt: 1),
            MyPresenter.InputItem(title: "title2", sourceInt: 2),
            MyPresenter.InputItem(title: "title3", sourceInt: 3)
        ])
        let expected = MyPresenter.OutputData.dummy(data: [
            TestCellViewData.Data(title: "title1->[from source: 1]", info: "odd source"),
            TestCellViewData.Data(title: "title2->[from source: 2]", info: "even source"),
            TestCellViewData.Data(title: "title3->[3]", info: "odd source")
        ])
        presenter.inputDataStream.accept(input)
        if let model = try! presenter.outputDataStream.skipWhile({ $0 == nil }).toBlocking(timeout: 3).first()! {
            XCTAssertTrue(model.data.elementsEqual(expected.data))
        } else {
            XCTAssert(false)
        }
    }
    
    func dummyDataServiceARequest() -> Single<[DataServiceA.RawModel]> {
        return Single<[DataServiceA.RawModel]>.create { [weak self] observer in
            if let self = self {
                let response = self.dummyDataServiceARequestResponse()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    observer(.success(response))
                }
            } else {
                observer(.error(NSError()))
            }
            return Disposables.create()
        }
    }

    func dummyDataServiceARequestResponse() -> [DataServiceA.RawModel] {
        let response = [
            DataServiceA.RawModel(title: "one", sourceNumStr: "1"),
            DataServiceA.RawModel(title: "two", sourceNumStr: "3"),
            DataServiceA.RawModel(title: "one", sourceNumStr: "7"),
            DataServiceA.RawModel(title: "three", sourceNumStr: "1"),
            DataServiceA.RawModel(title: "one", sourceNumStr: "2"),
            DataServiceA.RawModel(title: "three", sourceNumStr: "1"),
            DataServiceA.RawModel(title: "two", sourceNumStr: "10"),
        ]
        return response
    }

    func dummyDataServiceBRequest() -> Single<Bool> {
        return Single<Bool>.create { [weak self] observer in
            if let self = self {
                let response = self.dummyDataServiceBRequestResponse()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    observer(.success(response))
                }
            } else {
                observer(.error(NSError()))
            }
            return Disposables.create()
        }
    }
    
    func dummyDataServiceBRequestResponse() -> Bool {
        return true
    }
    
    func dummyDataServiceAOutput() -> DataServiceA.OutputData {
        return DataServiceA.OutputData.dummy(data: [
            DataServiceA.RawModel(title: "title1", sourceNumStr: "1"),
            DataServiceA.RawModel(title: "title2", sourceNumStr: "2"),
            DataServiceA.RawModel(title: "title3", sourceNumStr: "3")
        ], context: DataServiceA.Context(contextA: "contextA", contextB: -999))
    }
    
    func dummyDataServiceBOutput() -> DataServiceB.OutputData {
        return DataServiceB.OutputData.dummy(isChinese: true, context: "contextX")
    }
}
