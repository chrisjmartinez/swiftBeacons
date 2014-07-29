//
//  BeaconTableViewController.swift
//  BlueBeak Admin
//
//  Created by Chris Martinez on 7/19/14.
//  Copyright (c) 2014 Stoked Software, LLC. All rights reserved.
//

import UIKit

class BeaconTableViewController: UITableViewController {

    var companyID : String = ""
    var companyName : String = ""
    var items: NSArray = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Beacons for " + self.companyName

        self.getBeacons()
        
        var nibName=UINib(nibName: "BeaconTableViewCell", bundle:nil)
        
        tableView.registerNib(nibName, forCellReuseIdentifier: "BeaconCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.items.count
    }

    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell? {
        let cell = tableView.dequeueReusableCellWithIdentifier("BeaconCell", forIndexPath: indexPath) as BeaconTableViewCell
        let beacon = self.items.objectAtIndex(indexPath.row) as NSDictionary
        // Configure the cell...
        cell.name.text = beacon["name"] as String
        cell.uuid.text = beacon["mfg_id"] as String
        var s = beacon["major"] as NSNumber
        cell.major.text = s.stringValue
        s = beacon["minor"] as NSNumber
        cell.minor.text = s.stringValue
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, titleForHeaderInSection section: Int) -> String! {
        return "    Name                          UUID                                                                        Major          Minor"
    }

    override func tableView(tableView:UITableView!, heightForRowAtIndexPath indexPath:NSIndexPath)->CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var beaconView = storyboard.instantiateViewControllerWithIdentifier("Beacon") as BeaconSimViewController
        
        let beacon = self.items.objectAtIndex(indexPath.row) as NSDictionary
        
        beaconView.name = beacon["name"] as String
        beaconView.uuid = beacon["mfg_id"] as String
        beaconView.major = beacon["major"] as Int
        beaconView.minor = beacon["minor"] as Int
        
        self.navigationController.pushViewController(beaconView, animated: true)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    func getBeacons() {
        let baseURL = "http://getjulie.com:3000/beacons"
        var url : NSURL = NSURL.URLWithString(baseURL)
        var request: NSURLRequest = NSURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 15000)
        var config : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        var headers : NSDictionary = ["Content-type":"application/json", "Accept" : "application/json", "JULIE-CMP-KEY" : self.companyID]
        
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
                        
                        if(err?) {
                            // If there is an error parsing JSON, print it to the console
                            println("JSON Error \(err!.localizedDescription)")
                        }
                        var results: NSArray = json["payload"] as NSArray
                        dispatch_async(dispatch_get_main_queue(), {
                            self.items = results
                            self.tableView.reloadData()
                            })
                    }
                }
            }
            })
        
        // do whatever you need with the task
        task.resume()
    }
}
