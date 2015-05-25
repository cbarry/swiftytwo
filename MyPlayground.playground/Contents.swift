//: Playground - noun: a place where people can play

import UIKit
import Foundation
//import SwiftyJSON-master

private let kURLPath:String = "https://api.localytics.com/v1/query"

private let kAuth:String = "7bce70fb5dd9c2ff65681bc-c305980a-0181-11e5-9b52-00739d24cb30:d597836605864f97350e022-c3059c64-0181-11e5-9b52-00739d24cb30"
private let kAppID:String = "app_id=c2a7c12a4072295e3e0c086-8fb0828e-dd84-11e1-4a8f-00ef75f32667"

private let kRawQueryString:String = "conditions={\"day\":[\"between\",\"2015-05-01\",\"2015-05-23\"]}"
private let kQueryString:String = kRawQueryString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!

private func buildURL -> NSURL? {
    if let components:NSURLComponents = NSURLComponents(string:kURLPath) {
        components.queryItems = [NSURLQueryItem(name:"user", value:kAuth)]
        components.queryItems = [NSURLQueryItem(name:"data", value:kAppID)]
        components.queryItems = [NSURLQueryItem(name:"data", value:"metrics=users")]
        components.queryItems = [NSURLQueryItem(name:"data", value:"dimensions=day")]
        return components.URL
    }
    
    return nil
}

private func buildURLRequest -> NSURLRequest? {
    if let requestURL:NSURL = buildURL() {
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:requestURL)
        request.HTTPMethod = "GET"
        return request
    }
    return nil
}

private func FetchRequestParseData(receivedData:NSData, error:NSErrorPointer) -> NSDictionary? {
    return NSJSONSerialization.JSONObjectWithData(receivedData, options:NSJSONReadingOptions.MutableContainers, error:error) as? NSDictionary
}


class DataRequest: NSObject, NSURLConnectionDataDelegate
{
    private let appid:String
    private (set) var fetching:Bool
    private lazy var receivedData = NSMutableData()
    
    init(appid: String) {
        self.appid = appid
        self.fetching = false
    }
    
    func start() {
        assert(!fetching, "Should not start a request that has already started!")
        fetching = true
        if let request:NSURLRequest = buildURLRequest() {
            var connection:NSURLConnection = NSURLConnection(request:request, delegate:self, startImmediately:true)!
            connection.start()
        }
    }
    
    
    func connection(connection:NSURLConnection, didReceiveData data:NSData) {
        assert(fetching, "Should only receive data while activly fetching!")
        self.receivedData.appendData(data)
    }
    
    func connectionDidFinishLoading(connection:NSURLConnection) {
        var error:NSError?
        if let result:NSDictionary = FetchRequestParseData(receivedData, &error) {
            println(result)
        } else {
            println(error)
        }
        
    }
}

    
let fetcher:DataRequest = DataRequest(appid:"app_id=c2a7c12a4072295e3e0c086-8fb0828e-dd84-11e1-4a8f-00ef75f32667")
fetcher.start()
println(fetcher.receivedData)

