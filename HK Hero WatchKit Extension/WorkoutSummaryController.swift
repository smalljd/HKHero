//
//  WorkoutSummaryController.swift
//  HK Hero
//
//  Created by Small, Jeff on 1/10/16.
//  Copyright © 2016 Small, Jeff. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class WorkoutSummaryController: WKInterfaceController {

    @IBOutlet var heartRateLabel: WKInterfaceLabel!
    @IBOutlet var caloriesBurnedLabel: WKInterfaceLabel!
    @IBOutlet var averageHeartRateLabel: WKInterfaceLabel!
    
    var workoutSession: HKWorkoutSession?
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        if let workout = context as? HKWorkoutSession {
            workoutSession = workout
        } else {
            print("Invalid workout session 💩")
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // Execute queries using the workout session passed via context
        guard let workoutSession = workoutSession else {
            print("Can't display the workout information because it was nil at the time of presenting the interface controller.")
            return
        }
        
        displayEndingHeartRateInfo(forWorkout: workoutSession)
        displayCaloriesBurned(forWorkout: workoutSession)
        displayAverageHeartRate(forWorkout: workoutSession)
    }
    
    func displayAverageHeartRate(forWorkout workout: HKWorkoutSession) {
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let startDate = workout.startDate ?? NSDate.distantPast()
        let endDate = workout.endDate ?? NSDate()
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
            endDate: endDate,
            options: .None)
        let query = HKStatisticsQuery(quantityType: sampleType!,
            quantitySamplePredicate: predicate,
            options: .DiscreteAverage) { query, result, error -> Void in
            
            guard let quantity = result?.averageQuantity() else {
                print("No results for average heart rate: \(error?.userInfo)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                let unit = HKUnit(fromString: "count/s")
                let bpm = quantity.doubleValueForUnit(unit) * 60.0
                self.averageHeartRateLabel.setText("\(bpm) BPM")
            })
        }
        
        ExtensionDelegate.getHealthStore().executeQuery(query)
    }
    
    func displayCaloriesBurned(forWorkout workout: HKWorkoutSession) {
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierActiveEnergyBurned)
        let startDate = workout.startDate ?? NSDate.distantPast()
        let endDate = workout.endDate ?? NSDate()
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        let sortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // Build the query
        let query = HKSampleQuery(sampleType: sampleType!,
            predicate: predicate,
            limit: 1,
            sortDescriptors: [sortDescriptors]) { query, results, error in
            guard let results = results else {
                print("No results! \(error?.userInfo)")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                if let resultSample = results.first as? HKQuantitySample {
                    let unit = HKUnit.kilocalorieUnit()
                    let caloriesBurned = resultSample.quantity.doubleValueForUnit(unit) * 1000
                    self.caloriesBurnedLabel.setText("\(caloriesBurned) Cal")
                }
            })
        }
        
        ExtensionDelegate.getHealthStore().executeQuery(query)
    }
    
    func displayEndingHeartRateInfo(forWorkout workout: HKWorkoutSession) {
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let startDate = NSDate.distantPast()
        let endDate = workout.endDate ?? NSDate(timeIntervalSinceNow: 1)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        let sortDescriptors = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType!,
            predicate: predicate,
            limit: 1,
            sortDescriptors: [sortDescriptors]) { (query, results, error) -> Void in
                
                guard let results = results else {
                    print("There were no results 💩")
                    if let error = error {
                        print("Error: \(error.userInfo)")
                    }
                    return
                }
                
                if let heartRate = results.first as? HKQuantitySample {
                    let bpm = heartRate.quantity.doubleValueForUnit(HKUnit(fromString: "count/s")) * 60.0
                    print("Last heart rate sample: \(bpm)")
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let heartRate = results.first as? HKQuantitySample {
                        let bpm = heartRate.quantity.doubleValueForUnit(HKUnit(fromString: "count/s")) * 60.0
                        self.heartRateLabel.setText("\(bpm) BPM")
                    }
                })
        }
        
        ExtensionDelegate.getHealthStore().executeQuery(query)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func homeButtonTapped() {
        popToRootController()
    }
}
