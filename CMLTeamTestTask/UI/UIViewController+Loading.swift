//
//  UIViewController+Loading.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 23.04.2021.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func handleError(_ error: Error?) -> Bool {
        if let error = error {
            self.showSimpleAlert(title: "Error", message: error.localizedDescription)
            self.navigationController?.hideSpinner()
            return true
        } else {
            return false
        }
    }
    
    func showSimpleAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
