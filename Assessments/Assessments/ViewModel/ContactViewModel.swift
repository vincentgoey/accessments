//
//  ContactViewModel.swift
//  Assessments
//
//  Created by Kai Xuan on 17/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import Foundation

struct ContactViewModel {

    private var contactsList = [Contact]()
    
    mutating func retrieveData(contacts: [Contact]) {
        //Clear Old data
        self.contactsList.removeAll()
        //Add new data
        contacts.forEach { (contact) in
            self.contactsList.append(contact)
        }
    }
    
    func numberOfRows(_ section: Int) -> Int {
        return self.contactsList.count
    }
    
    func modelAt(_ index: Int) -> Contact {
        return self.contactsList[index]
    }

}
