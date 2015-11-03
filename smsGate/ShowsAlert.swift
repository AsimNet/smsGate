//
//  ShowsAlert.swift
//  triplog
//
//  Created by Asim al twijry on 10/27/15.
//  Copyright © 2015 sadeemApps. All rights reserved.
//

import UIKit
protocol ShowsAlert {}


extension ShowsAlert where Self: UIViewController {
    func showAlert(title: String = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
    }
}