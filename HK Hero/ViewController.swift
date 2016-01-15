//
//  ViewController.swift
//  HK Hero
//
//  Created by Small, Jeff on 1/10/16.
//  Copyright © 2016 Small, Jeff. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let shareTypes = Set<HKSampleType>(arrayLiteral:
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDistanceWalkingRunning)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)!,
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!
        )
        AppDelegate.getHealthStore().requestAuthorizationToShareTypes(shareTypes, readTypes: shareTypes) { (success, error) -> Void in
            if !success {
                print("Access denied")
            }
            if error != nil {
                print("Error requesting permission: \(error!.userInfo)")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

