//
//  GapViewModel.swift
//  iOS Interview
//
//  Created by Alvin Tu on 10/21/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation
struct GapViewModel {
    
    private var _gapLabelString: String!
    var gapLabelString: String {
        return _gapLabelString
    }

    init(startOfGap:Int, endOfGap:Int) {
        self._gapLabelString = getGapStringFrom(startOfGap: startOfGap, endOfGap: endOfGap)
   }

    
    func getGapStringFrom(startOfGap:Int,endOfGap:Int)->String{
        let startTuple = secondsToHoursMinutesSeconds(seconds: startOfGap)
        let startMinutes = timeTupleToMinutes(timeTuple: startTuple)
//        let durationPlusStart = startOfGap + duration
        let endingTimeTuple = secondsToHoursMinutesSeconds(seconds: endOfGap)
        let endMinutes = timeTupleToMinutes(timeTuple: endingTimeTuple)
        
        let actualStartTime = startTuple.0.description + ":" + startMinutes
        let actualEndTime =   endingTimeTuple.0.description + ":" +  endMinutes
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: actualStartTime)
        let date1 = dateFormatter.date(from: actualEndTime)
        dateFormatter.dateFormat = "h:mma"
        let Date12Start = dateFormatter.string(from: date!)
        let Date12End = dateFormatter.string(from: date1!)
        return "No Therapist: " + Date12Start + " to " +  Date12End
    }
    
    fileprivate func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    fileprivate func timeTupleToMinutes(timeTuple: (Int, Int, Int)) -> String{
        var minutes = ""
          if timeTuple.1 < 10{
              minutes = "0" + timeTuple.1.description
          } else{
              minutes = timeTuple.1.description
          }
        return minutes
    }
    
}
