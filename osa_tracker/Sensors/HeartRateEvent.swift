//
//  HeartRateEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 18/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct HeartRateEvent:EventProtocol {
    var sensorName: String
    var timestamp: Date
    var sessionIdentifier:String?
    
    private var event:EventData
    
    private struct EventData:Codable{
        var unit:String
        var heartRate:Double
    }
    
    
    init(unit:String, heartRate:Double) {
        self.timestamp = Date()
        self.sensorName = "Heart Rate"
        self.event = EventData(unit: unit, heartRate: heartRate)
    }
    
    init(unit:String, heartRate:Double, sessionIdentifier:UUID) {
        self.timestamp = Date()
        self.sensorName = "Heart Rate"
        self.event = EventData(unit: unit, heartRate: heartRate)
        self.sessionIdentifier = sessionIdentifier.description
    }
    
    func getHR() -> Double{
        return event.heartRate
    }
    
    func getHRUnit() -> String{
        return event.unit
    }
}
