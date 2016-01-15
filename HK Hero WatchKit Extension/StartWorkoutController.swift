//
//  StartWorkoutController.swift
//  HK Hero
//
//  Created by Small, Jeff on 1/10/16.
//  Copyright © 2016 Small, Jeff. All rights reserved.
//

import WatchKit
import HealthKit
import Foundation


class StartWorkoutController: WKInterfaceController {

    var workoutStarted = false
    var workoutSession: HKWorkoutSession?
    var workoutType: HKWorkoutActivityType?
    
    @IBOutlet var workoutTimer: WKInterfaceTimer!
    @IBOutlet var startStopButton: WKInterfaceButton!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if let contextString = context as? String {
            if contextString.caseInsensitiveCompare("archery") == .OrderedSame {
                workoutType = .Archery
            } else if contextString.caseInsensitiveCompare("martial arts") == .OrderedSame {
                workoutType = .MartialArts
            } else if contextString.caseInsensitiveCompare("running") == .OrderedSame {
                workoutType = .Running
            } else if contextString.caseInsensitiveCompare("swimming") == .OrderedSame {
                workoutType = .Swimming
            } else {
                workoutType = .MartialArts
            }
        }
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

    @IBAction func startStopWorkoutButtonTapped() {
        if !workoutStarted {
            guard let workoutType = workoutType else {
                print("Workout type isn't set")
                return
            }
            workoutTimer.setDate(NSDate())
            startStopButton.setBackgroundColor(UIColor.redColor())
            startStopButton.setTitle("Stop")
            workoutSession = HKWorkoutSession(activityType: workoutType, locationType: .Unknown)
            ExtensionDelegate.getHealthStore().startWorkoutSession(workoutSession!)
            workoutTimer.start()
            workoutStarted = !workoutStarted
        } else {
            ExtensionDelegate.getHealthStore().endWorkoutSession(workoutSession!)
            workoutTimer.stop()
            startStopButton.setEnabled(false)
            startStopButton.setBackgroundColor(UIColor(red: 0, green: 128/255.0, blue: 0, alpha: 1.0))
            startStopButton.setTitle("Start")
            workoutStarted = !workoutStarted
            pushControllerWithName("workoutSummaryController", context: workoutSession!)
        }
    }
}

extension StartWorkoutController: HKWorkoutSessionDelegate {
    func workoutSession(workoutSession: HKWorkoutSession, didChangeToState toState: HKWorkoutSessionState, fromState: HKWorkoutSessionState, date: NSDate) {
        print("State changed from \(fromState) to \(toState)")
    }
    
    func workoutSession(workoutSession: HKWorkoutSession, didFailWithError error: NSError) {
        print("Workout session failed: \(error.userInfo)")
    }
}
