//
//  NetworkService.swift
//  MyBackEnd
//
//  Created by Suman Chatterjee on 3/18/18.
//  Copyright © 2018 Suman Chatterjee. All rights reserved.
//

import Foundation

enum FetchInfoError : String {
    case  locationError = "We're having trouble finding the location"
    case  serverError   = "The weather service is not working."
    case  networkError  = "The network appears to be down."
    case  dataError     = "We're having trouble processing weather data."
    case  urlError      = "We're having trouble with the specified URL."
    
}


enum State {
    case notFetchededYet
    case loading
    case noResults
    case dataError
    case result(Location)
    case error(NetworkError)
}


typealias FetchComplete = (Bool,String?) -> Void

class NetworkService:ApiResource {
    
    private var dataTask: URLSessionDataTask? = nil
    private(set) var requestType: RequestType = .location
    private(set) var state: State = .notFetchededYet
    private(set) var request:URLRequest?
    
    
    
    init(for requestType: RequestType , with data:[String:Any]) {

        self.requestType = requestType
        
        guard let url = self.url else {
            state = .dataError
            return
        }
        
        request = URLRequest(url: url)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.httpMethod = "POST"
        
        // prepare json data
        let jsonData = try? JSONSerialization.data(withJSONObject: data)
        request?.httpBody = jsonData
        
    }
    
    
    func fetchData(completion: @escaping FetchComplete) {

        dataTask?.cancel()
        // Update state
        var success = false
        state = .notFetchededYet
        
        let session = URLSession.shared

        guard let request = self.request else {
            completion(success,FetchInfoError.dataError.rawValue)
            return
        }
        
        dataTask = session.dataTask(with: request, completionHandler: {
            data, response, error in
            var newState = State.notFetchededYet
            if let error = error as NSError?, error.code == -999 {
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(success,FetchInfoError.dataError.rawValue)
                return
            }
            
            if httpResponse.statusCode == 200, let data = data {
                guard let fetchResult = ParseJson.parse(data: data) else {
                    newState = .noResults
                    completion(success,FetchInfoError.dataError.rawValue)
                    return
                }
                newState = .result(fetchResult)
                success = true
            }else if httpResponse.statusCode == 400, let data = data {
                guard let fetchResult = ParseJsonError.parse(data: data) else {
                    newState = .noResults
                    completion(success,FetchInfoError.dataError.rawValue)
                    return
                }
                newState = .error(fetchResult)
                success = true
            }
            
            DispatchQueue.main.async {
                self.state = newState
                completion(success, nil)
            }
        })
        dataTask?.resume()
    }
}
