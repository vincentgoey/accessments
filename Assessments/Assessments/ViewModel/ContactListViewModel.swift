//
//  ContactViewModel.swift
//  Assessments
//
//  Created by Kai Xuan on 17/01/2020.
//  Copyright © 2020 Kai Xuan. All rights reserved.
//

import Foundation

protocol addContactDelegate {
    func addContact(contact: Contact)
}

struct ContactListViewModel {

    private var contactsList = [Contact]()
    
    mutating func saveContact(contact: Contact) {
        
        //Create new ID for new Contact
        var contactNeedToBeSaveOrUpdate = contact

        //id validation to check is new contact of existing contact
        if (contactNeedToBeSaveOrUpdate.id ?? "").isEmpty {
            // Assuming First Data Contain Id, and chances of random strjng duplicates is very low, comparison will affect performances
            contactNeedToBeSaveOrUpdate.id = generateId(self.contactsList[0].id!.count)
            self.contactsList.append(contactNeedToBeSaveOrUpdate)
        } else {

            let validationContact = self.contactsList.filter({return $0.id == contactNeedToBeSaveOrUpdate.id}).first ?? nil

            if (validationContact != nil) {

                let existingContact = self.contactsList.filter({return $0.id == contactNeedToBeSaveOrUpdate.id})
                
                // Map Back The Lastest Data
                self.contactsList = self.contactsList.map { (contact) -> Contact in
                    var contactToBeUpdate = contact
                    if contactToBeUpdate.id == existingContact[0].id {
                        contactToBeUpdate = contactNeedToBeSaveOrUpdate
                    }
                    return contactToBeUpdate
                }
                
            } else {
                // if Id not found, insert as new object
                self.contactsList.append(contactNeedToBeSaveOrUpdate)
            }
        }
    }
    
    mutating func retrieveData(contacts: [Contact]) {
        //Clear Old data
        self.contactsList.removeAll()
        //Add new data
        contacts.forEach { (contact) in
            self.contactsList.append(contact)
        }
    }
    
    func numberOfRows() -> Int {
        return self.contactsList.count
    }
    
    func modelAt(_ index: Int) -> Contact {
        return self.contactsList[index]
    }
    
    func toArray() -> [Contact] {
        return self.contactsList.map{$0}
    }
    
    func generateId(_ n: Int) -> String
    {
        //Random Generate Id from this string
        let characterSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"

        var idGenerated = ""

        for _ in 0..<n
        {
            let r = Int(arc4random_uniform(UInt32(characterSet.count)))

            idGenerated += String(characterSet[characterSet.index(characterSet.startIndex, offsetBy: r)])
        }
        
        //Assign Date with Time to make sure id is unique
        let currentDate = Date()
        let since1970 = currentDate.timeIntervalSince1970
        let millieSeconds = Int(since1970 * 1000)

        return idGenerated+String(millieSeconds)
    }
    
    func fetchData() -> [Contact]   {
        if let path = Bundle.main.path(forResource: "data", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let contactlists = try JSONDecoder().decode([Contact].self, from: data)
                return contactlists
            } catch {}
        }
        return []
    }
    
    func updateData() {
        if let path = Bundle.main.path(forResource: "data", ofType: "json"){
            do {
                let listOfContacts = self.toArray()
                let writePath = URL(fileURLWithPath: path)
                try JSONEncoder().encode(listOfContacts).write(to: writePath)
            } catch let error{print(error)}
        }
    }

}
