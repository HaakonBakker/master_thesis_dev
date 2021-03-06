//
//  CloudHandler.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 16/10/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitSink:Sink{
    
    /**
     Returns a bool depending on whether or not the upload was successful. If it failed the application should handle it gracefully.
     The upload_text function will upload data to iCloud. THIS FUNCTION UPLOADS TO THE PUBLIC CLOUD.
     */
    static func runSink(events:[Data], sessionIdentifier:String) -> [Data]{
        // Convert all data objects to strings and append.
        let jsonString = getArrayAsJsonString(array: events)
        
        let fh = FileHandler()
        let fileUrl = fh.write_file(filename: "bucket.txt", contents: jsonString)
        
        if let fileURL = fileUrl{
            
            let sessionRecord = CKRecord(recordType: "Buckets")

            sessionRecord["data"] = CKAsset(fileURL: fileURL)
            sessionRecord["eventCount"] = events.count
            sessionRecord["sessionIdentifier"] = sessionIdentifier

            CKContainer.default().publicCloudDatabase.save(sessionRecord) { [] record, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Upload Error: \(error.localizedDescription)")
                        print("Upload Error: \(self)")
                    } else {
                        print("Done!")
                        print(record ?? "NA")
                    }
                }
            }
        }
        return events
    }
    
    static func runSink(events:[Data]) -> [Data]{
        // Convert all data objects to strings and append.
        fatalError("Need to call the runSink function with sessionIdentifier as a parameter.")
    }
    
    static func uploadAggregated(sessionIdentifier:String, eventCount:Int64, batteryLevel:Double){
        let sessionRecord = CKRecord(recordType: "SamplingData")

        sessionRecord["aggregatedEventCount"] = eventCount
        sessionRecord["batteryLevel"] = batteryLevel
        sessionRecord["sessionIdentifier"] = sessionIdentifier

        CKContainer.default().publicCloudDatabase.save(sessionRecord) { [] record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Upload Error: \(error.localizedDescription)")
                    print("Upload Error: \(self)")
                } else {
                    print("SamplingData: Done!")
                    print(record ?? "NA")
                }
            }
        }
    }
    
    static func createSession(sessionIdentifier:String){
        let sessionRecord = CKRecord(recordType: "Session")
        sessionRecord["sessionIdentifier"] = sessionIdentifier

        CKContainer.default().publicCloudDatabase.save(sessionRecord) { [] record, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Upload Error: \(error.localizedDescription)")
                    print("Upload Error: \(self)")
                } else {
                    print("Created Session in CloudKit!")
                    print(record ?? "NA")
                }
            }
        }
    }
    
    static func getArrayAsJsonString(array:[Data]) -> String {
        var jsonString:String = "["
        for event in array {
            if let json = String(data: event, encoding: .utf8) {
                jsonString += json + ","
            }
        }
        jsonString += "]"
        
        return jsonString
    }
}
