//
//  DataServiceState.swift
//  CleanArch
//
//  Created by HU Siwei on 2020/6/3.
//

import RxSwift

enum DataServiceState {
    case loading
    case error(Error)
    case success
    case none
    
    var loading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    var error: Error? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
    
    var success: Bool {
        if case .success = self {
            return true
        }
        return false
    }
}

protocol DataServiceStateProtocol {
    // State Stream
    var stateStream: Observable<DataServiceState> { get }
}
