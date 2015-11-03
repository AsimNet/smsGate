//
//  GroupDetailsView.swift
//  smsGate
//
//  Created by Asim al twijry on 10/30/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import ContactsUI
import Contacts
import RealmSwift




class GroupDetailsView: UITableViewController,CNContactPickerDelegate,UIPickerViewDelegate {
    // MARK: - Variables - Outlets

    //** Contacts instance **//
    let contactStore = CNContactStore()
    
    //** Group object **//
    var selectedGroup : Group!
    
    var strings : [String] = [""]
   
    // MARK: - buttons' Actions

    @IBAction func selectContacts(sender: AnyObject) {
       
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.delegate = self
        print("result : \(strings)")
        
        contactPickerViewController.predicateForEnablingContact =
            NSPredicate(format:
                "NOT (givenName IN %@) AND phoneNumbers.@count > 0",
                argumentArray: strings)
        
        //        print("result33 : \(        contactPickerViewController.predicateForEnablingContact!.predicateFormat)")
        
        
        
        contactPickerViewController.view.tintColor = self.view.tintColor
        
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey]
        
        presentViewController(contactPickerViewController, animated: true, completion: nil)
    }
    
    
    // MARK: - Contacts Methods

    func contactPicker(picker: CNContactPickerViewController,
        didSelectContacts contacts: [CNContact]) {
            print("Selected \(contacts.count) contacts")
     
            
            
            
            for var i = 0;i < contacts.count;i++ {
                let dummycontact = contacts[i]
                let phoneNumber = dummycontact.phoneNumbers[0].value as! CNPhoneNumber
                
                    let result = selectedGroup.contacts.filter { $0.name == (dummycontact.givenName) }

                    print("result : \(result)")
                    if result.isEmpty {
                        // contact does not exist in array

                        let saveContact = Contact()
                        saveContact.name = dummycontact.givenName
                        saveContact.mobileNumber = phoneNumber.stringValue
                        
                        try! Realm().write({
                            self.selectedGroup.contacts.append(saveContact)
                            
                        })
                    }

            
            }
            
            tableView.reloadData()
            updatePromptString()

    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return selectedGroup.contacts.count
    }
    
 
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
      
        var dummyContact : Contact!
        
        dummyContact = selectedGroup.contacts[indexPath.row]
        
        cell.textLabel?.text = dummyContact.mobileNumber
        cell.detailTextLabel?.text = dummyContact.name
        strings.append(dummyContact.name)
        return cell
    }

    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            // Delete the row from the data source
            
            var dummyContact : Contact!
            
            dummyContact = selectedGroup.contacts[indexPath.row]

     try! uiRealm.write({ () -> Void in
            uiRealm.delete(dummyContact)
        })
        
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        updatePromptString()

        }
    
    // MARK:- custom method 
    
    func updatePromptString() -> Void {
        
        let promptString:String
        let contactNo = selectedGroup.contacts.count
        
        if(contactNo == 0){
            promptString = "لا يوجد مستقبلين"
            
        }else if (contactNo == 1){
            promptString = "رقم واحد"
        }else if (contactNo == 2 ){
            promptString = "رقمين"
        }else if (contactNo > 2 && contactNo < 11){
            promptString = String(contactNo) + " أرقام"
        }else{
            promptString = String(contactNo) + " رقم"
        }

        self.navigationItem.prompt = promptString

    }
}
