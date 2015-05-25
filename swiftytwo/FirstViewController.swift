//
//  FirstViewController.swift
//  swiftytwo
//
//  Created by cbarry on 5/23/15.
//  Copyright (c) 2015 cbarry. All rights reserved.
//

import UIKit


import Foundation
// import SwiftyJSON

func SendQueryAPIRequest(username:String, password:String, urlString:String) -> NSDictionary? {
    /*let username:String
    let password:String
    let urlString:String
    
    init(username:String, password:String, urlString:String) {
        self.username = username
        self.password = password
        self.urlString = urlString
    }*/
    
    // Format credentials
    let loginString = NSString(format: "%@:%@", username, password)
    let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
    let base64LoginString = loginData.base64EncodedStringWithOptions(nil)

    // create the request
    let url = NSURL(string: urlString)
    let request = NSMutableURLRequest(URL: url!)
    request.HTTPMethod = "GET"
    request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
    
    // fire off the request
    var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
    var dataVal: NSData =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error:nil)!
    var err: NSError
    var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary

    return jsonResult
}


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // set up the base64-encoded credentials
        let username:String = "7bce70fb5dd9c2ff65681bc-c305980a-0181-11e5-9b52-00739d24cb30"
        let password:String = "d597836605864f97350e022-c3059c64-0181-11e5-9b52-00739d24cb30"
        let urlString:String = "https://api.localytics.com/v1/query?&app_id%5B%5D=c2a7c12a4072295e3e0c086-8fb0828e-dd84-11e1-4a8f-00ef75f32667&conditions%5Bday%5D%5B%5D=between&conditions%5Bday%5D%5B%5D=2015-04-01&conditions%5Bday%5D%5B%5D=2015-04-30&dimensions%5B%5D=day&limit=50000&metrics%5B%5D=users&order%5B%5D=%2Bday&order%5B%5D=-users&sampling_ratio=1.0"

        let result:NSDictionary! = SendQueryAPIRequest(username,password, urlString)
        // println("\(result)")
        
        let jsonResult = JSON(result)
        
        println(jsonResult["results"])
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

