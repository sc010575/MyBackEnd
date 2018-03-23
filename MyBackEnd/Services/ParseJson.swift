//
//  ParseJson.swift
//  MyBackEnd
//
//  Created by Suman Chatterjee on 3/18/18.
//  Copyright © 2018 Suman Chatterjee. All rights reserved.
//

import Foundation

protocol Serialize {
    associatedtype model
    static func parse(data: Data) -> model?
}

final class ParseJson<T:Codable>: Serialize {
    
    typealias model = T
    class func parse(data: Data) -> T? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from:data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
}

final class ParseJsonError: Serialize {
    
    typealias model = NetworkError
    class func parse(data: Data) -> NetworkError? {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(NetworkError.self, from:data)
            return result
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
}

