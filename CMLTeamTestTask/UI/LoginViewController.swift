//
//  ViewController.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 4/22/21.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit
import BoxView

class LoginViewController: ScrollViewController {
    let emailField = UITextField(placeholder: "Email", returnKeyType: .next)
    let passwordField = UITextField(placeholder: "Password", returnKeyType: .done)
    let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        contentView.spacing = 16.0
        contentView.items = [
            emailField.boxed,
            passwordField.boxed,
            submitButton.boxed.bottom(>=0.0)
        ]
        emailField.delegate = self
        passwordField.delegate = self
        submitButton.backgroundColor = UIColor.init(named: "appBlue")
        submitButton.setTitle("Log in", for: .normal)
        submitButton.addTarget(self, action: #selector(clickedSubmitButton), for: .touchUpInside)
        submitButton.layer.cornerRadius = 6.0
        navigationItem.title = "Sign In"
    }

    @objc func clickedSubmitButton() {
        guard let email = emailField.text, let password = passwordField.text else {return}
        let creds = Credentials(email: email, password: password)
        self.navigationController?.showSpinner()
        NetworkManager.shared.authorise(credentials: creds) { [unowned self] (error) in
            guard !self.handleError(error) else { return }
            NetworkManager.shared.loadUser { (user, error) in
                guard !self.handleError(error) else {
                    return
                }
                self.navigationController?.hideSpinner()
                let propertiesVC = PropertiesViewController(user: user!)
                navigationController?.setViewControllers([propertiesVC], animated: true)
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else {
            clickedSubmitButton()
        }
        return false
    }
}

extension UITextField {
    convenience init(placeholder: String?, returnKeyType: UIReturnKeyType) {
        self.init()
        self.placeholder = placeholder
        self.borderStyle = .roundedRect
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.returnKeyType = returnKeyType
    }
}
