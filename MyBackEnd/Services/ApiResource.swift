//
//  ApiResource.swift
//  MyBackEnd
//
//  Created by Suman Chatterjee on 3/18/18.
//  Copyright © 2018 Suman Chatterjee. All rights reserved.
//

import Foundation

enum RequestType: String{
    case location   = "update_location"
    case register   = "register"
}

protocol ApiResource  {
    var requestType:RequestType { get }
}

extension ApiResource {
    var url: URL? {
        let baseUrl = "http://192.168.0.25:5000"
        let url = baseUrl + "/" + requestType.rawValue
        guard let finalUrl = URL(string: url) else { return nil}
        return finalUrl
    }
}
