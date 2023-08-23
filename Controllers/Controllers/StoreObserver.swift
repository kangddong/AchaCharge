//
//  StoreObserver.swift
//  Controllers
//
//  Created by 강동영 on 2023/08/24.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
                ....
    //Initialize the store observer.
    override init() {
        super.init()
        //Other initialization here.
    }


    //Observe transaction updates.
    func paymentQueue(_ queue: SKPaymentQueue,updatedTransactions transactions: [SKPaymentTransaction]) {
        //Handle transaction states here.
    }
                ....
}
