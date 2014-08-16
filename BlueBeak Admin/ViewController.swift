//
//  ViewController.swift
//  BlueBeak Admin
//
//  Created by Chris Martinez on 6/11/14.
//  Copyright (c) 2014 Stoked Software, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet
    var pickerView: UIPickerView!
    
    var items: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.getCompanies()
        self.title = "Company"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int {
        return self.items.count
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int) {
        var dict : NSDictionary = self.items[row] as NSDictionary
        var companyID : String = dict["id"] as String
        var beaconView = storyboard.instantiateViewControllerWithIdentifier("Beacons") as BeaconTableViewController
        
        beaconView.companyID = companyID
        beaconView.companyName = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        self.navigationController.pushViewController(beaconView, animated: true)
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        var dict : NSDictionary = self.items[row] as NSDictionary
        var name : AnyObject! = dict["name"]
        return name as NSString
    }
    
    func getCompanies() {
        let baseURL = "http://getjulie.com:3000/companies"
        var url : NSURL = NSURL.URLWithString(baseURL)
        var request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 15000)
        var config : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var headers : NSDictionary = ["Content-type":"application/json", "Accept" : "application/json"]
        
        config.HTTPAdditionalHeaders = headers
        
        let session = NSURLSession(configuration:config)

        //request.HTTPMethod = "GET"
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            if(error) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            } else {
                // your code
                let httpResponse : NSHTTPURLResponse = response as NSHTTPURLResponse
                if (httpResponse.statusCode == 200) {
                    if (data.length > 0) {
                        // Convert response to JSON
                        var err: NSError?
                        var json : NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
                        
                        if(err != nil) {
                            // If there is an error parsing JSON, print it to the console
                            println("JSON Error \(err!.localizedDescription)")
                        }
                        var results: NSArray = json["payload"] as NSArray
                        dispatch_async(dispatch_get_main_queue(), {
                            self.items = results
                            self.pickerView.reloadAllComponents()
                        })
                    }
                }
            }
        })
        
        // do whatever you need with the task
        task.resume()
    }
}

