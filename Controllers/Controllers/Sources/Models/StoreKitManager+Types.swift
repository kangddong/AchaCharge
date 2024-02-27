//
//  StoreKitManager+Types.swift
//  Controllers
//
//  Created by 강동영 on 2/28/24.
//

import Foundation

/// Fetch receipt result
public enum FetchReceiptResult {
    case success(receiptData: Data)
    case error(error: ReceiptError)
}

/// Error when managing receipt
public enum ReceiptError: Swift.Error {
    /// No receipt data
    case noReceiptData
    /// No data received
    case noRemoteData
    /// Error when encoding HTTP body into JSON
    case requestBodyEncodeError(error: Swift.Error)
    /// Error when proceeding request
    case networkError(error: Swift.Error)
    /// Error when decoding response
    case jsonDecodeError(string: String?)
    /// Receive invalid - bad status returned
//    case receiptInvalid(receipt: ReceiptInfo, status: ReceiptStatus)
}
