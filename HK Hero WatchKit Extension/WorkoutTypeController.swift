//
//  WorkoutTypeController.swift
//  HK Hero
//
//  Created by Small, Jeff on 1/10/16.
//  Copyright © 2016 Small, Jeff. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class WorkoutTypeController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    override func contextForSegueWithIdentifier(segueIdentifier: String) -> AnyObject? {
        
        if segueIdentifier.caseInsensitiveCompare("archeryIdentifier") == .OrderedSame {
            return "archery"
        }
        
        if segueIdentifier.caseInsensitiveCompare("martialArtsIdentifier") == .OrderedSame {
            return "martial arts"
        }
        
        if segueIdentifier.caseInsensitiveCompare("runningIdentifier") == .OrderedSame {
            return "running"
        }
        
        if segueIdentifier.caseInsensitiveCompare("swimmingIdentifier") == .OrderedSame {
            return "swimming"
        }
        
        return "martial arts"
    }
}
