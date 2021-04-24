//
//  NSError+Custom.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 23.04.2021.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import Foundation

extension NSError {

    convenience init(errorData: Data, defaultMessage: String? = nil) {
        
        // in the case of API error response contains message field with error description
        // so we can wrap it into NSError to show in alert
        if let apiError = try? JSONDecoder().decode(APIError.self, from: errorData) {
            self.init(domain: "API error", code: apiError.httpCode, userInfo: [NSLocalizedDescriptionKey: apiError.message])
        }
        else {
            self.init(domain: "unknown error", code: 0, userInfo: [NSLocalizedDescriptionKey: defaultMessage ?? "Oops! Something went wrong!"])
        }
    }
    
    convenience init(message: String) {
        self.init(domain: "App error", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
