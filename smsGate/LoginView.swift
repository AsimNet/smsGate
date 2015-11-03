//
//  LoginView.swift
//  smsGate
//
//  Created by Asim al twijry on 10/27/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import Alamofire
class LoginView: UITableViewController ,ShowsAlert{
    @IBOutlet var userName: UITextField!

    @IBOutlet var tagName: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBAction func loginAction(sender: AnyObject) {
        var success : Bool = false
        
        Alamofire.request(.POST, "http://api.smsgw.net/GetCredit", parameters: ["strUserName":userName.text!,
            "strPassword":password.text!])
            .responseString {response in
                
                success = response.result.isSuccess
                if(success){
                  
                    print(response.result.value!)
                    if(response.result.value! == "-1"){
                        //error , Login again
                        
                        self.showAlert("خطأ", message: "اسم المستخدم أو كلمة المرور خاطئة")
                        return
                    }else{
                        NSUserDefaults().setBool(true, forKey: "loggedin?")
                         NSUserDefaults().setObject(response.result.value!, forKey: "credits")
                        
                        NSUserDefaults().setObject(self.tagName.text!, forKey: "tagName")
                        NSUserDefaults().setObject(self.userName.text!, forKey: "userName")
                        NSUserDefaults().setObject(self.password.text!, forKey: "password")

                        self.dismissViewControllerAnimated(true, completion: nil)

                        
                    }

                }
        }

        
        

    }
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.navigationItem.setHidesBackButton(true, animated:true);

     
    }


}
