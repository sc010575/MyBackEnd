//
//  RegistrationTest.swift
//  MyBackEndTests
//
//  Created by Suman Chatterjee on 4/1/18.
//  Copyright © 2018 Suman Chatterjee. All rights reserved.
//

import XCTest
import Nimble
import Quick

@testable import MyBackEnd

class RegistrationTest: QuickSpec {
    override func spec() {
        describe("NetworkService tests") {
            
            context("when connect to the registration service for a valid user data") {
                it("returns a success") {
                    
                    let downloadExpectiation = self.expectation(description: "Network service for .all")
                    
                    let json: [String: Any] = ["username": "A User",
                                               "password": "A password",
                                               "email_address": "aemail@email.com",
                                               "phone_number":7856]
                    
                    let networkService = NetworkService(for: .register, with: json)
                    expect(networkService.request?.httpMethod).to(equal("POST"), description: "The http method should be the expected one")
                    
                    networkService.fetchData(completion: { (success, data, error) in
                        
                        if success {
                            guard let data = data, let fetchResult:Token = ParseJson.parse(data: data) else {
                                return
                            }
                            print(fetchResult.token)
                            expect(fetchResult.status) == "success"
                            expect(fetchResult.token).toNot(beNil(), description: "A token is expected")
                        }else{
                            expect(success) == false
                            
                        }
                        downloadExpectiation.fulfill()
                        
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
