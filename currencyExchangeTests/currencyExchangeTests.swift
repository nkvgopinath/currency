//
//  currencyExchangeTests.swift
//  currencyExchangeTests
//
//  Created by Gopinath Vaiyapuri on 30/11/24.
//

import XCTest
import Combine

@testable import currencyExchange

final class currencyExchangeTests: XCTestCase {

    var repository: CountryRepository!
    var mockAPIClient: MockAPIClient!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockAPIClient = MockAPIClient()
        repository = CountryRepository(mockAPIClient)

        
    }

    override func tearDownWithError() throws {
        repository = nil
        mockAPIClient = nil

        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testGetCountryListSuccess() {
           mockAPIClient.shouldReturnError = false
           let expectation = self.expectation(description: "Country List Loaded Successfully")
           
        repository.getCountryList { result in
               switch result {
               case .success(let countries):
                   XCTAssertGreaterThan(countries.count, 0)
               case .failure(let error):
                   XCTFail("Expected success but got failure: \(error.localizedDescription)")
               }
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 7, handler: nil)
       }
    
    
    
    
    func testGetCurrentExchangeRateSuccess() {
           mockAPIClient.shouldReturnError = false
           let expectation = self.expectation(description: "Exchange Rate Loaded Successfully")
           
        repository.getCurrentExchangeRate { result in
               switch result {
               case .success(let exchangeRate):
                   XCTAssertEqual(exchangeRate.result, "success")
               case .failure(let error):
                   XCTFail("Expected success but got failure: \(error.localizedDescription)")
               }
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 1, handler: nil)
       }

}



class MockAPIClient: APIClient {
    var shouldReturnError: Bool = false
    
    func perform<T: Decodable>(_ request: APIRequest, _ model: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Network error"])))
        } else {
            if model == [CountriesModel].self {
                completion(.success([model] as! T))
            } else if model == ExchangeRateModel.self {
                completion(.success(model as! T))
            }
        }
    }
}





