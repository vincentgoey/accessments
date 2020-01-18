//
//  AssessmentsTests.swift
//  AssessmentsTests
//
//  Created by Kai Xuan on 17/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import XCTest
@testable import Assessments

class AssessmentsTests: XCTestCase {

    private var contactListViewModels = ContactListViewModel()

    func test_addContact() {
        
        //testCase For Add Contact
        let contact = Contact(id: contactListViewModels.generateId(24), firstName: "testing", lastName: "function", email: nil, phone: nil)
        let currentCount = contactListViewModels.numberOfRows()
        
        contactListViewModels.saveContact(contact: contact)
        
        //Check currentCount should be increment by 1
        XCTAssertEqual(contactListViewModels.numberOfRows(), currentCount+1)
        
    }
    
    func test_retrieveData() {
        //testCase get data from data.json
        contactListViewModels.retrieveData(contacts: contactListViewModels.fetchData())
        let result = contactListViewModels.numberOfRows() > 0 ? true : false
        XCTAssertTrue(result)
    }
    
    func test_writeData() {
        //testCase write data to data.json
        //get current data count
        contactListViewModels.retrieveData(contacts: contactListViewModels.fetchData())
        let currentCount = contactListViewModels.numberOfRows()
        // insert new contact
        let contact = Contact(id: contactListViewModels.generateId(24), firstName: "testing", lastName: "function", email: nil, phone: nil)
        contactListViewModels.saveContact(contact: contact)
        contactListViewModels.updateData()
        
        //get latest count after add
        contactListViewModels.retrieveData(contacts: contactListViewModels.fetchData())
        
        //compare count
        XCTAssertEqual(contactListViewModels.numberOfRows(), currentCount+1)
    }
    
    override func tearDown() {
        super.tearDown()
    }

}
