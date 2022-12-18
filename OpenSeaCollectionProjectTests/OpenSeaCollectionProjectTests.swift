//
//  OpenSeaCollectionProjectTests.swift
//  OpenSeaCollectionProjectTests
//
//  Created by Polo on 2022/12/14.
//

import XCTest
import Combine

@testable import OpenSeaCollectionProject

final class OpenSeaCollectionProjectTests: XCTestCase {

    var cancellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    private var assetService: AssetService!
    private var etherscanService: EtherscanService!
    private var assetListViewModel: AssetListViewModel!
    
    override func setUp() {
        cancellable = Set<AnyCancellable>()
        assetService = AssetService()
        etherscanService = EtherscanService()
        assetListViewModel = AssetListViewModel(repositories: assetService, etherscanRepositories: etherscanService)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        assetService = nil
        etherscanService = nil
        assetListViewModel = nil
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

    func test_verify_getAssets() {
        let exp = XCTestExpectation(description: #function)
        assetService.getAssets(with: "0x85fD692D2a075908079261F5E351e7fE0267dB02", offset: 0)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                case .finished:
                    break
                }
                exp.fulfill()
            } receiveValue: { items in
                XCTAssertEqual(items.count > 0 , true)
                exp.fulfill()
            }.store(in: &cancellable)
        wait(for: [exp], timeout: 5)
    }
    
    
    func test_verify_getEtherscanAccount() {
        let exp = XCTestExpectation(description: #function)
        etherscanService.getBalance(with: "0x45e538f3c138a1580850d7e822b68e995e787033")
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                case .finished:
                    break
                }
                exp.fulfill()
            } receiveValue: { item in
                XCTAssertEqual(item.account == "0x45e538f3c138a1580850d7e822b68e995e787033" , true)
                exp.fulfill()
            }.store(in: &cancellable)
        wait(for: [exp], timeout: 5)
    }
    
    func test_assetlist_loadmore() {
        let exp = XCTestExpectation(description: #function)

        sleep(5)
        
        assetListViewModel.$assetState
            .dropFirst()
            .sink { complection in
                print("complection")
            } receiveValue: { [weak self] state in
                if self?.assetListViewModel.assetState == .finishedLoading && state == .finishedLoading {
                    self?.assetListViewModel.loadMoreAssetIfNeeded()
                }
            }.store(in: &cancellable)
    
        assetListViewModel.$assets
            .dropFirst(2)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                case .finished:
                    break
                }
                exp.fulfill()
            } receiveValue: { items in
                XCTAssertEqual(items.count > 20 , true)
                exp.fulfill()
            }.store(in: &cancellable)
        
        wait(for: [exp], timeout: 20)
    }
}
