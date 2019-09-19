//
//  AudioSensorInterface.swift
//  osa_tracker
//
//  Created by Haakon W Hoel Bakker on 28/08/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import Foundation

protocol AudioSensorInterface  {
    // Data about the sensor
    var sampleRate:Int {get set}
    var numberOfChannels:Int {get set}
    
    // Functions we need for the interface
    func startRecording() -> Bool
    func endRecording(success: Bool)
    func pauseRecording()
    func saveRecording()
}
