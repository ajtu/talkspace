//
//  TherapistViewModel.swift
//  iOS Interview
//
//  Created by Alvin Tu on 10/20/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation

struct TherapistViewModel {
//    let onDutyLabelString: String
//    let timeUntilShiftEndsOrStartsLabelString: String
    private var _nameLabelString: String!
    var nameLabelString: String {
        return _nameLabelString
    }
    private var _primaryLicenseLabelString: String!
    var primaryLicenseLabelString: String {
        return _primaryLicenseLabelString
    }
    private var _shiftTimeLabelString: String!
       var shiftTimeLabelString: String {
           return _shiftTimeLabelString
       }
    
    private var _timeUntilShiftEndsOrStartsLabelString: String!
       var timeUntilShiftEndsOrStartsLabelString: String {
           return _timeUntilShiftEndsOrStartsLabelString
       }
    var timeUntilEnds = 0
    var timeUntilStarts = 0


    
    // Dependency Injection (DI)
    init(therapist: Therapist) {
        self._nameLabelString = getFirstNameFromFullName(fullName: therapist.name)
        self._primaryLicenseLabelString = getPrimaryLicenseSinceStringFrom(primaryLicense: therapist.primaryLicense, therapistSince: therapist.therapistSince)
        self._shiftTimeLabelString = getShiftTimeLabelStringShiftInfo(start: therapist.shiftInfo.start, duration: therapist.shiftInfo.duration)
        self._timeUntilShiftEndsOrStartsLabelString = getShiftEndingOrStartingBasedonLocalTime(startOfSession: therapist.shiftInfo.start, durationOfSession: therapist.shiftInfo.duration)
        self.timeUntilStarts = getTimeUntil(startOfSession: therapist.shiftInfo.start, durationOfSession: therapist.shiftInfo.duration)
        self.timeUntilEnds = getTimeUntilSessionEnds(startOfSession: therapist.shiftInfo.start, durationOfSession: therapist.shiftInfo.duration)
    }
    
    
    private func getFirstNameFromFullName(fullName:String)->String{
        let fullName = fullName
        var lastName = ""
               var components = fullName.components(separatedBy: " ")
               if components.count > 0
               {
                _ = components.removeFirst()
                   lastName = components.joined(separator: " ")
               }
        return lastName
    }
    private func getPrimaryLicenseSinceStringFrom(primaryLicense:String, therapistSince:Double)->String{
        let timeResult = therapistSince
        let date = NSDate(timeIntervalSince1970: timeResult)
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.setLocalizedDateFormatFromTemplate("ddMMyyyy")
        let localDate = dateFormatter.string(from: date as Date)
        
        return primaryLicense + " since " + localDate
    }
    
    private func getShiftTimeLabelStringShiftInfo(start:Int, duration:Int) -> String{
        let startTuple = secondsToHoursMinutesSeconds(seconds: start)
        let startMinutes = timeTupleToMinutes(timeTuple: startTuple)
        let durationPlusStart = start + duration
        let endingTimeTuple = secondsToHoursMinutesSeconds(seconds: durationPlusStart)
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
        return Date12Start + " to " +  Date12End
    }
    
    private mutating func getShiftEndingOrStartingBasedonLocalTime(startOfSession:Int, durationOfSession:Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = Date()
        let localDate = dateFormatter.string(from: date as Date)

        let lengthOfDaySoFar = localDate.secondFromString
        let durationPlusStart = durationOfSession + startOfSession
        
        
        if lengthOfDaySoFar > startOfSession && lengthOfDaySoFar < durationPlusStart{
            let timeUntilSessionEnds = durationPlusStart - lengthOfDaySoFar
            let sessionEndsTuple = secondsToHoursMinutesSeconds(seconds: timeUntilSessionEnds)
            let sessionEndMinutes = timeTupleToMinutes(timeTuple: sessionEndsTuple)
            let actualSessionEndTime = sessionEndsTuple.0.description + "hr" + sessionEndMinutes + "min"
            self.timeUntilEnds = timeUntilSessionEnds
            return (actualSessionEndTime + " til end")
            }
        else if lengthOfDaySoFar < startOfSession{
            let timeUntilSessionStarts = startOfSession - lengthOfDaySoFar
            let sessionStartsTuple = secondsToHoursMinutesSeconds(seconds: timeUntilSessionStarts)
            let sessionStartMinutes = timeTupleToMinutes(timeTuple: sessionStartsTuple)
            let actualSessionStartTime = sessionStartsTuple.0.description + "hr" + sessionStartMinutes + "min"
            self.timeUntilEnds = timeUntilSessionStarts

            return actualSessionStartTime + " til start"
    }
        else{
            return ""
        }
    }
        private func getTimeUntil(startOfSession:Int, durationOfSession:Int) -> Int{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let date = Date()
            let localDate = dateFormatter.string(from: date as Date)
            
            let lengthOfDaySoFar = localDate.secondFromString
            let timeUntilSessionStarts = startOfSession - lengthOfDaySoFar
//            print(timeUntilSessionStarts)
            return timeUntilSessionStarts
    }
    
     private func getTimeUntilSessionEnds(startOfSession:Int, durationOfSession:Int) -> Int{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                let date = Date()
                let localDate = dateFormatter.string(from: date as Date)
                let durationPlusStart = startOfSession + durationOfSession
                let lengthOfDaySoFar = localDate.secondFromString
                let timeUntilSessionEnds = durationPlusStart - lengthOfDaySoFar
        if lengthOfDaySoFar > startOfSession && lengthOfDaySoFar < durationPlusStart{

                return timeUntilSessionEnds
        } else{
            return 0
        }
    }
    
        
    
//helper functions
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

extension String{

    var integer: Int {
        return Int(self) ?? 0
    }
    var secondFromString : Int{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
//        let seconds = components[2].integer
//        return Int((hours * 60 * 60) + (minutes * 60) + seconds)
        return Int((hours * 60 * 60) + (minutes * 60) )

    }
    
    var minutesFromString : Int{
           let components: Array = self.components(separatedBy: ":")
           let hours = components[0].integer
           let minutes = components[1].integer
        print(String(minutes))
//           let seconds = components[2].integer
           return Int((hours * 60) + (minutes) )
       }
}
