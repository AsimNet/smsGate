//
//  Group.swift
//  smsGate
//
//  Created by Asim al twijry on 10/28/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import RealmSwift

class Group: Object {

    dynamic var gName:String = ""
     let contacts = List<Contact>()

   
   
}
