//
//  InAppReceiptRefreshRequest.swift
//  Controllers
//
//  Created by 강동영 on 2/28/24.
//

import StoreKit
import Foundation

class InAppReceiptRefreshRequest: NSObject, SKRequestDelegate, InAppRequest {

    enum ResultType {
        case success
        case error(e: Error)
    }

    typealias RequestCallback = (ResultType) -> Void
    typealias ReceiptRefresh = (_ receiptProperties: [String: Any]?, _ callback: @escaping RequestCallback) -> InAppReceiptRefreshRequest

    class func refresh(_ receiptProperties: [String: Any]? = nil, callback: @escaping RequestCallback) -> InAppReceiptRefreshRequest {
        let request = InAppReceiptRefreshRequest(receiptProperties: receiptProperties, callback: callback)
        request.start()
        return request
    }

    let refreshReceiptRequest: SKReceiptRefreshRequest
    let callback: RequestCallback

    deinit {
        refreshReceiptRequest.delegate = nil
    }

    init(receiptProperties: [String: Any]? = nil, callback: @escaping RequestCallback) {
        self.callback = callback
        self.refreshReceiptRequest = SKReceiptRefreshRequest(receiptProperties: receiptProperties)
        super.init()
        self.refreshReceiptRequest.delegate = self
    }

    func start() {
        self.refreshReceiptRequest.start()
    }

    func cancel() {
        self.refreshReceiptRequest.cancel()
    }
    
    func requestDidFinish(_ request: SKRequest) {
        /*if let resoreRequest = request as? SKReceiptRefreshRequest {
         let receiptProperties = resoreRequest.receiptProperties ?? [:]
         for (k, v) in receiptProperties {
         print("\(k): \(v)")
         }
         }*/
        performCallback(.success)
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        // XXX could here check domain and error code to return typed exception
        performCallback(.error(e: error))
    }
    private func performCallback(_ result: ResultType) {
        DispatchQueue.main.async {
            self.callback(result)
        }
    }
}
