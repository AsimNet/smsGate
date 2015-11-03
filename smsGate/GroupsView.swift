//
//  GroupsView.swift
//  smsGate
//
//  Created by Asim al twijry on 10/27/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsView: UITableViewController {
    
    // MARK: - Variables - Outlets

  static var selectMood = false
    var groups : Results<Group>!
    
    var selectedGroup:String?

    
    // MARK: - lifeCycle's methods
    override func viewWillAppear(animated: Bool) {
        groups = uiRealm.objects(Group)
        
        selectedGroup = NSUserDefaults().stringForKey("selectedGroup")

        self.tableView.reloadData()

    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        let group = groups[indexPath.row]
        
        let cellLabel = group.gName + " (" + String(group.contacts.count) + ")"
        print(selectedGroup)
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        
        if(selectedGroup == group.gName){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        cell.textLabel?.text = cellLabel
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let group = groups[indexPath.row]
        if(!GroupsView.selectMood){
        let contactNo = group.contacts.count
        let promptString: String?
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GroupDetailsView") as? GroupDetailsView
        
      vc?.selectedGroup = groups[indexPath.row]
        
        vc?.navigationItem.title = group.gName
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
        
        vc?.navigationItem.prompt = promptString
        
        self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            
            GroupsView.selectMood = false
            selectedGroup = group.gName
            
            NSUserDefaults().setValue(selectedGroup, forKey: "selectedGroup")
            self.navigationController?.popViewControllerAnimated(true)
            
            
            
            
        }
        
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let group = groups[indexPath.row]

            try! Realm().write({
                uiRealm.delete(group )
                
            })
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    


}
