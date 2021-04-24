//
//  SpinnerView.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 23.04.2021.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit
import BoxView

class SpinnerView: BoxView {

    private let activityView = UIActivityIndicatorView()

    override func setup() {
        backgroundColor = .init(white: 0.75, alpha: 0.75)
        items = [activityView.boxed.centerX().centerY()]
        activityView.style = .whiteLarge
        activityView.startAnimating()
    }

}

extension UIViewController {
    func  showSpinner() {
        view.addBoxedView(SpinnerView())
    }

    func  hideSpinner() {
        view.subviews.first(where: { $0 is SpinnerView })?.removeFromSuperview()
    }
}
