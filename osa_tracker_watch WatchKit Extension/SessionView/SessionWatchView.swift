//
//  SessionView.swift
//  osa_tracker_watch WatchKit Extension
//
//  Created by Haakon W Hoel Bakker on 25/09/2019.
//  Copyright © 2019 Haakon W Hoel Bakker. All rights reserved.
//

import SwiftUI

struct SessionWatchView: View {
    var sessionController = SessionController()
    @State var numberOfEvents = 0
    @State var hr_rate = "-"
    @State var current_time = Date().dateToHour()
    @State var duration_string = "00:00"
    @State var batteryPerc:String = "-"
    
    @State private var sessionStarted: Bool = false
    @State private var sessionEnded:Bool = false
    var onDismiss: () -> ()
    
    // Timer to update the view
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.numberOfEvents = self.sessionController.getNumberOfEvents()
            self.hr_rate = self.sessionController.getLatestHeartRateData()
            self.duration_string = self.sessionController.getSessionDurationString(session: self.sessionController.currentSession!)
            self.current_time = Date().dateToHour()
            self.batteryPerc = self.sessionController.getLatestBatteryWatchEvent()
            
        }
    }
    
    var body: some View {
        VStack{
            if(sessionStarted){
                if(sessionEnded){
                    VStack{
                        Text("Session ended").font(.caption)
                        Button(action: {
                            print("Pressed going home");
                            self.onDismiss()
                        }) {
                            Text("Home")
                        }
                    }.onAppear(perform: {self.timer.invalidate()})
                }else{
                    VStack(alignment: .leading){
                        Text("Active session").font(.caption)
                        HStack{
                            Text("# Events: \(self.numberOfEvents)")
                        }
                        
                        // Adding some default information
                        HStack{
                            Text("🕑: \(self.current_time)")
                        }
                        
                        HStack{
                            Text("⏱: \(self.duration_string)")
                        }
                        HStack{
                            Text("💗: \(self.hr_rate)")
                        }
                        HStack{
                            Text("🔋: \(self.batteryPerc)")
                        }
                        
                        Spacer()
                        Button(action: {
                            print("End button pressed");
                            self.sessionEnded = true;
                            self.sessionController.endSession()
                        }) {
                            Text("End session")
                        }
                    }.onAppear(perform: {
                        _ = self.timer
                    })
                }
                
            }else{
                Text("Watch ready")
                Button(action: {
                    print("Start button pressed");
                    self.sessionStarted = true;
                    _ = self.sessionController.startSession(wakeUpTime: Date());
                }) {
                    Text("Start session")
                }
            }
        }
        
        
        
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionWatchView(onDismiss: {})
    }
}
