//
//  PropertiesViewController.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 4/22/21.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit

class PropertiesViewController: UIViewController {
    
    let tableView = UITableView()
    
    private var user: User
    
    var items = [Property]()
    
    let reuseIdentifier = "PropertiesTableView"
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = user.firstName + " " + user.lastName
        view.addBoxedView(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        // not registering cell class because we need .subtitle style, not default UITableViewCell
        self.navigationController?.showSpinner()
        NetworkManager.shared.loadItems(accountID: user.accountId) { (properties, error) in
            guard !self.handleError(error) else { return }
            self.navigationController?.hideSpinner()
            self.items = properties!
            self.tableView.reloadData()
        }
        self.tableView.backgroundColor = UIColor.init(named: "backGray")
    }
    
}

extension PropertiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let property = items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let detailsVC = DetailsViewController(property: property)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension PropertiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Instead of registering cell class we directly create cells with .subtitle style when there are no cells in a buffer
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        let property = items[indexPath.row]
        cell.textLabel?.text = property.name
        cell.detailTextLabel?.text = property.address()
        cell.backgroundColor = UIColor.init(named: "backGray")
        return cell
    }
}
