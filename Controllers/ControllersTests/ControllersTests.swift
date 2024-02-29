//
//  ControllersTests.swift
//  ControllersTests
//
//  Created by 강동영 on 2023/08/09.
//

import XCTest

final class ControllersTests: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
        measure {}
    }

    func testFetchingProductIdentifiers() {
        let productType: [String] = TestProductIDs.allCases.map { $0.identifier }
        let result = getProductIdentifiers()
        
        switch result {
        case .success(let identifiers):
            let productIdentifiers = Array(Set(identifiers))
            print("Test >> productIdentifiers: \(productIdentifiers)")
            print("Test >> productType's identifiers: \(productType)")
            XCTAssertTrue(productType.count == productIdentifiers.count)
            XCTAssertTrue(productType.contains(productIdentifiers))
        case .failure(let error):
            print("\(error.localizedDescription)")
        }
    }
    
    private func getProductIdentifiers() -> Result<[String], Error> {
        var productIDs: [String] = []
        
        guard let url = Bundle.main.url(forResource: "ProductIDs", withExtension: "plist") else {
            fatalError("Unable to resolve url for in the bundle.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let productIdentifiers = try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String]
            productIDs = productIdentifiers ?? []
            
            return .success(productIDs)
        } catch let error as NSError {
            return .failure(error)
        }
    }
}
