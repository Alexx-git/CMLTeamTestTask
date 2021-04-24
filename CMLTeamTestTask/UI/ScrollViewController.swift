//
//  ScrollViewController.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 23.04.2021.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit
import BoxView

class ScrollViewController: UIViewController {
    let scrollView = UIScrollView()
    let contentView = BoxView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.contentInset.bottom = 0
    }

    private func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        scrollView.contentInset.bottom = view.convert(keyboardFrame.cgRectValue, from: nil).size.height
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)
        let guide = view.safeAreaLayoutGuide
        guide.addBoxItems([scrollView.boxed])
        view.backgroundColor = UIColor.init(named: "backGray")
        scrollView.addBoxedView(contentView)
        contentView.pinWidth(to: scrollView)
    }
}
