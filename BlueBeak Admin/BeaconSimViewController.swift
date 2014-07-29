//
//  BeaconSimViewController.swift
//  BlueBeak Admin
//
//  Created by Chris Martinez on 7/20/14.
//  Copyright (c) 2014 Stoked Software, LLC. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import CoreBluetooth

class BeaconSimViewController: UIViewController, CBPeripheralManagerDelegate {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var uuidLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var minorLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    var name : String = ""
    var uuid : String = ""
    var major : Int = 0
    var minor : Int = 0
    
    var beaconRegion :  CLBeaconRegion!
    var beaconPeripheralData : NSDictionary!
    var peripheralManager : CBPeripheralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Transmitting"
        // Do any additional setup after loading the view.
        nameLabel.text = name
        uuidLabel.text = uuid
        var number : NSNumber = major
        majorLabel.text = number.stringValue
        number = minor
        minorLabel.text = number.stringValue
    }

    func animate() {
        let theAnimation = CABasicAnimation(keyPath: "transform")
        theAnimation.duration = 1
        theAnimation.repeatCount=HUGE
        theAnimation.autoreverses=true
        theAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        theAnimation.fromValue = NSValue(CATransform3D: CATransform3DMakeScale(1, 1, 0))
        theAnimation.toValue = NSValue(CATransform3D: CATransform3DMakeScale(0.5, 0.5, 0))
        self.image.layer.addAnimation(theAnimation, forKey: "pulse")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        powerOn()
        animate()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.image.layer.removeAllAnimations()
        powerOff()
    }
    
    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func powerOn () {
        var maj = CLBeaconMajorValue(major)
        var min = CLBeaconMinorValue(minor)
        var uuid = NSUUID(UUIDString: self.uuid)
        
        self.beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: maj, minor: min, identifier: name)
        self.beaconPeripheralData = self.beaconRegion.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func powerOff () {
        self.peripheralManager.stopAdvertising()
    }

    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        if (peripheral.state == CBPeripheralManagerState.PoweredOn) {
            self.peripheralManager.startAdvertising(self.beaconPeripheralData)
        } else if (peripheral.state == CBPeripheralManagerState.PoweredOff) {
            self.peripheralManager.stopAdvertising()
        }
    }
}
