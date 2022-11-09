//
//  MyViewController.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/5/30.
//

import Foundation
import UIKit
import RxSwift

final class MyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let dataServiceA: DataServiceAProtocol & MyDataPipeProtocol
    let combinedDataService: MyDataServiceProtocol & MyDataPipeProtocol
    let presenter: MyPresenterProtocol
    let disposeBag = DisposeBag()
    
    init() {
        presenter = MyPresenter()
        dataServiceA = DataServiceA()
        combinedDataService = MyDataService()
        super.init(nibName: String(describing: MyViewController.self), bundle: nil)
    }
    
    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        bind()
        dataServiceA.fetchData(contextA: "contextA", contextB: 0)
        // Or
//        combinedDataService.fetchData(myContext: "my context")
    }
    
    func config() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: String(describing: TestCell.self), bundle: nil), forCellReuseIdentifier: Constant.cellId)
    }
    
    func bind() {
        // set up
        dataServiceA.setup(presenter: presenter)
        // or
        combinedDataService.setup(presenter: presenter)

        // bind - data stream
        presenter.outputDataStream.subscribe(onNext: { [weak self] (data) in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        // bind - state stream
        dataServiceA.stateStream.subscribe(onNext: { [weak self] (state) in
            let loading = state.loading
            self?.activityIndicator.startAnimating()
            self?.activityIndicator.isHidden = !loading
            self?.tableView.isHidden = loading
        }).disposed(by: disposeBag)
        
        combinedDataService.stateStream.subscribe(onNext: { [weak self] (state) in
            let loading = state.loading
            self?.activityIndicator.startAnimating()
            self?.activityIndicator.isHidden = !loading
            self?.tableView.isHidden = loading
        }).disposed(by: disposeBag)
    }
}

extension MyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constant.cellId, for: indexPath) as? TestCell {
            let viewData = presenter.viewData(at: indexPath)
            TestCellViewData.config(cell: cell, data: viewData)
            // Or
            // TestCellViewData.config(cell: cell, title: viewData.title, info: viewData.info)
            return cell
        }
        return UITableViewCell()
    }
}

extension MyViewController {
    struct Constant {
        static let cellId = "cellId"
    }
}
