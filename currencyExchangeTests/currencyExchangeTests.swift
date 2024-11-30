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

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false


        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
    func testInitialUIElementsExist() throws {
            let navigationBar = app.otherElements["NavigationBarView"]
            let countryPicker = app.otherElements["countryPickerView"]
            let deliveryPicker = app.otherElements["deliverMethod"]
            let depositView = app.otherElements["DepositView"]
            let exchangePaymentPicker = app.otherElements["exchangePaymentView"]
            
            XCTAssertTrue(navigationBar.exists, "Navigation bar should exist")
            XCTAssertTrue(countryPicker.exists, "Country picker should exist")
            XCTAssertTrue(deliveryPicker.exists, "Delivery picker should exist")
            XCTAssertTrue(depositView.exists, "Deposit view should exist")
            XCTAssertTrue(exchangePaymentPicker.exists, "Exchange payment picker should exist")
        }
    
    
    func testSelectCountryPicker() throws {
        let countryPicker = app.otherElements["countryPickerView"]
        XCTAssertTrue(countryPicker.exists, "Country picker should exist")
        
        countryPicker.tap()
        
        let countryListModal = app.collectionViews["CountryPickerCollection"]
        XCTAssertTrue(countryListModal.waitForExistence(timeout: 10), "Country list modal should appear")
        
        let countryCell = countryListModal.cells.staticTexts["India"]
        XCTAssertTrue(countryCell.exists, "Country 'India' should exist in the list")
        countryCell.tap()
        
        let countryPlaceholder = countryPicker.staticTexts["India"]
        XCTAssertTrue(countryPlaceholder.exists, "Country picker placeholder should display the selected country")
    }
    
    func testSelectDeliveryMethod() throws {
        let deliveryPicker = app.otherElements["deliverMethod"]
        XCTAssertTrue(deliveryPicker.exists, "Delivery picker should exist")
        
        deliveryPicker.tap()
        
    }
}
