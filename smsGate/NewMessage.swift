//
//  NewMessage.swift
//  smsGate
//
//  Created by Asim al twijry on 10/30/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class NewMessage: UITableViewController,ShowsAlert {

    // MARK: - Variables - Outlets

    @IBOutlet var selectedGroupOutlet: UIButton!
    var groups : Results<Group>!
    @IBOutlet var textMessage: UITextView!
    
    
    // MARK: - buttons' Actions

    @IBAction func sendAction(sender: AnyObject) {
        let userName = NSUserDefaults().stringForKey("userName")
        let tagName = NSUserDefaults().stringForKey("tagName")
        let password = NSUserDefaults().stringForKey("password")
        
        let selectedGroupgName = NSUserDefaults().stringForKey("selectedGroup")
        let groups = uiRealm.objects(Group).filter({
            $0.gName == selectedGroupgName!
        })
        
        print(groups)
        var recivers = [String]()
        
        //     recivers.removeAll()
        for Contact in groups[0].contacts{
            //            groups[0].contacts[0].mobileNumber
            let modified = Contact.mobileNumber.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            recivers.append(modified)
        }
        print(recivers)
        
        let reciversString = recivers.joinWithSeparator(",") // "1-2-3"
        

        postAPI("http://api.smsgw.net/SendBulkSMS", Params: [
            "strUserName":userName!,
            "strPassword":password!,
            "strTagName" : tagName!,
            "strRecepientNumbers" : reciversString,
            "strMessage" : textMessage.text!
            ])
        connectAPI("http://api.smsgw.net/GetCredit",params: ["strUserName":userName!,
            "strPassword":password!])
    }
    
    @IBAction func selectGroup(sender: AnyObject) {
      
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("GroupsView") as? GroupsView
vc?.navigationItem.prompt = "حدد مجموعة لاستقبال الرسائل"
        
        GroupsView.selectMood = true
        
navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    // MARK: - lifeCycle's methods

    override func viewWillAppear(animated: Bool) {
        let selectedGroup = NSUserDefaults().stringForKey("selectedGroup")
        
        let userName = NSUserDefaults().stringForKey("userName")
        let password = NSUserDefaults().stringForKey("password")
        connectAPI("http://api.smsgw.net/GetCredit",params: ["strUserName":userName!,
            "strPassword":password!])

        print("selectedGroup1 : ",selectedGroup)
        if(selectedGroup != nil){
        selectedGroupOutlet.setTitle(selectedGroup, forState: UIControlState.Normal)
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        let isUserLoggedin : Bool = NSUserDefaults().boolForKey("loggedin?")

        if(!isUserLoggedin){
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginView") as? LoginView
           
            vc!.navigationItem.hidesBackButton=true;
            presentViewController(vc!, animated: true, completion: nil)
        }else{
            
        }
        

    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.Interactive
     
        let credits = (NSUserDefaults().stringForKey("credits"))!
        
        self.navigationItem.prompt = "الرصيد : " + credits + " رسالة"
        
        }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        textMessage.endEditing(true)
    }
 
    
    // MARK: - API Methods (get - post)
    
    func connectAPI(URL:String,params:NSDictionary)-> String{
        var success : Bool = false
        
        //zero means there's an errror with api request
        var returnValue = "0"
        
        
        Alamofire.request(.POST,URL, parameters:params as? [String : AnyObject])
            .responseString {response in
                
                success = response.result.isSuccess
                if(success){
                    
                    print(response.result.value!)
                    if(response.result.value! == "-1"){
                        //error , Login again
                        
                        self.showAlert("خطأ", message: "اسم المستخدم أو كلمة المرور خاطئة")
                        return
                    }else{
                        NSUserDefaults().setObject(response.result.value!, forKey: "credits")
                        
                        let credits = (NSUserDefaults().stringForKey("credits"))!
                        
                        self.navigationItem.prompt = "الرصيد : " + credits + " رسالة"
                        returnValue = response.result.value!
                        
                    }
                    
                }
        }
        
        
        return returnValue
        
    }
    
    
    func postAPI(URL:String, Params:NSDictionary)-> Void{
        
               Alamofire.request(.POST, URL, parameters:Params as? [String : AnyObject])
            .responseString {response in
                
                let  success = response.result.isSuccess
                print(response.result.value!)
                
                if(success){
                    
                    if(response.result.value! == "-1"){
                        //error , Login again
                        
                        self.showAlert("خطأ", message: "اسم المستخدم أو كلمة المرور خاطئة")
                        return
                    }else if (response.result.value! == "1"){
                        self.showAlert("تم", message: "تم إرسال الرسالة بنجاح")
                    }
                    
                }
        }
        

    }

  






}
