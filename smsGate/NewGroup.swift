//
//  NewGroup.swift
//  smsGate
//
//  Created by Asim al twijry on 10/28/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import RealmSwift

class NewGroup: UITableViewController {
    // MARK: - Variables - Outlets

    @IBOutlet var groupNameField: UITextField!
    
    // MARK: - buttons' Actions

    @IBAction func doneAction(sender: AnyObject) {
        let groupName = Group()
        groupName.gName = groupNameField.text!
     try! uiRealm.write { () -> Void in
            uiRealm.add(groupName)
        }
        

        navigationController?.popViewControllerAnimated(true)
        
    }

}
