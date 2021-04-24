//
//  URL+Creation.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 23.04.2021.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import Foundation

extension URL {
    
    static func make(base: String, endpoint: String, query: [String: String]? = nil) -> URL {
        var url = URL(string: base)?.appendingPathComponent(endpoint)
        if let pars = query {
            url = url?.withParameters(pars)
        }
        return url!
    }
    
    var command: String? {
        return self.host?.lowercased()
    }
    
    var queryParameters: [String: String] {
        var map = [String: String]()
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        components?.queryItems?.forEach { map[$0.name] = $0.value }
        return map
    }
    
    func withParameters(_ parameters: [String: String]) -> Self {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        return urlComponents?.url ?? self
    }

}
