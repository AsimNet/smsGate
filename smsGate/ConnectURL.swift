//
//  ConnectURL.swift
//  smsGate
//
//  Created by Asim al twijry on 11/2/15.
//  Copyright © 2015 AsimNet. All rights reserved.
//

import UIKit
import Alamofire

class ConnectURL: NSObject {
   static var apiResponse :String = "0"

   static  func connectAndPost(URL:String, Params: NSDictionary)->Void{
        
        var success : Bool = false
    
        Alamofire.request(.POST, URL, parameters: Params as? [String : AnyObject])
            .responseString {
                response in

                success = response.result.isSuccess
                if(success){
                apiResponse = response.result.value!
                
                }
        }
    }
}
