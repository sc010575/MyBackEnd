//
//  MyBackEndTests.swift
//  MyBackEndTests
//
//  Created by Suman Chatterjee on 3/18/18.
//  Copyright © 2018 Suman Chatterjee. All rights reserved.
//

import XCTest
import Nimble
import Quick

@testable import MyBackEnd

class NetworkServiceTests: QuickSpec {
    override func spec() {
        describe("NetworkService tests") {

            context("when connect to the network service for a valid location") {
                it("returns a success") {

                    let downloadExpectiation = self.expectation(description: "Network service for .all")

                    let json: [String: Any] = ["address": "123 Fake Street",
                        "lat": "25.308337", "lon": "101.544880"]

                    let networkService = NetworkService(for: .location, with: json)
                    expect(networkService.request?.httpMethod).to(equal("POST"), description: "The http method should be the expected one")

                    networkService.fetchData(completion: { (success, error) in
                        if !success {
                            XCTAssert(success, error ?? "Some unknown error")
                        }

                        downloadExpectiation.fulfill()

                        switch networkService.state {
                        case .notFetchededYet, .loading, .noResults, .dataError, .error(_ ):
                            return
                        case .result(let location):
                            expect(location.status) == "success"
                            expect(location.message) == "location 123 Fake Street updated to coordinates 25.308337 101.544880 "
                        }

                    })

                    self.waitForExpectations(timeout: 10) { (error) in

                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }

                }
            }


            context("when connect to the network service for a invalid longitude location ") {
                fit("returns a success") {
                    
                    let downloadExpectiation = self.expectation(description: "Network service for .location")
                    
                    let json: [String: Any] = ["address": "123 Fake Street",
                                               "lat": "25.308337", "lon": "-455"]
                    
                    let networkService = NetworkService(for: .location, with: json)
                    expect(networkService.request?.httpMethod).to(equal("POST"), description: "The http method should be the expected one")
                    
                    networkService.fetchData(completion: { (success, error) in
                        if !success {
                            XCTAssert(success, error ?? "Some unknown error")
                        }
                        
                        downloadExpectiation.fulfill()
                        
                        switch networkService.state {
                        case .notFetchededYet, .loading, .noResults, .dataError :
                            return
                        case .error(let networkError):
                            expect(networkError.status) == "error"
                            expect(networkError.error) == "lat must be a float or an int value"
                        case .result(_):
                            return
                        }
                        
                    })
                    
                    self.waitForExpectations(timeout: 10) { (error) in
                        
                        if let error = error {
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                    
                }
            }
        }
    }
}

