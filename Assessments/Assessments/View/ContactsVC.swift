//
//  ContactsVC.swift
//  Assessments
//
//  Created by Kai Xuan on 17/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import UIKit

class ContactsVC: UIViewController {
    
    var tableView = UITableView()
    private var contactListViewModels = ContactListViewModel()
    
    struct Cells {
        static let contactCell = "ContactCell"
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Updating") //if you want a text
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.contactListViewModels.retrieveData(contacts: self.contactListViewModels.fetchData())
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupNavBar()
        configureTableView()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        setTableViewDelegate()
        tableView.rowHeight = 80
        tableView.register(ContactCell.self, forCellReuseIdentifier: Cells.contactCell)
        tableView.tableFooterView = UIView()
        tableView.refreshControl = refreshControl
        tableView.pin(to: view)
        
    }
    
    func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupNavBar() {
        self.title = "Contacts"
        
        //setup Right Navigation Button
        let imageIcon = UIImage(named: appConstant.addIcon)
        let rightButton = UIBarButtonItem(image: imageIcon,  style: .plain, target: self, action:#selector(addNewContact))
        rightButton.tintColor = hexStringToUIColor(hex: appConstant.themeColor)
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    func setupData() {
        //read lastest data
        self.contactListViewModels.retrieveData(contacts: self.contactListViewModels.fetchData())
    }

}

extension ContactsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactListViewModels.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.contactCell) as! ContactCell
        cell.contactModel = self.contactListViewModels.modelAt(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let vc = ContactDetailsVC()
        vc.contactDetails.contact   = self.contactListViewModels.modelAt(indexPath.row)
        vc.addContactDelegate       = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContactsVC {
    
    @objc func addNewContact(){
        let vc = ContactDetailsVC()
        vc.contactDetails.contact   = nil
        vc.addContactDelegate       = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ContactsVC: addContactDelegate {
    
    func addContact(contact: Contact) {
        self.contactListViewModels.saveContact(contact: contact)
        self.contactListViewModels.updateData()
        self.tableView.reloadData()
    }
    
}
