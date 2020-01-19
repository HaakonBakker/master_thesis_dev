//
//  MetaStopEvent.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 13/10/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

struct MetaStopEvent: EventProtocol, Codable {
    var sessionIdentifier: String
    var timestamp: TimeInterval
    var sensorName: String
    private var event:EventData
    
    private struct EventData:Codable{
        var totalCount:Int
        var type = "End"
    }
    
    init(sessionIdentifier:String, totalCount:Int) {
        self.timestamp = Date().timeIntervalSince1970
        self.sensorName = "MetaStopEvent"
        self.sessionIdentifier = sessionIdentifier
        self.event = EventData(totalCount: totalCount)
    }
}
