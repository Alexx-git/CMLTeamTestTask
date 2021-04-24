//
//  String+HTML.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 23.04.2021.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        // NSAttributed string parsed from html may have too snall font,
        // so we change it to fixed size
        let modifiedStr = String(format: "<span style=\"font-family: '-apple-system', Helvetica; font-size: \(16); color: black ; \">%@</span>", self)

        guard let data = modifiedStr.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
