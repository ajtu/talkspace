//
//  Therapist.swift
//  iOS Interview
//
//  Created by Alvin Tu on 10/18/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation
struct Therapists: Codable {
    let therapists:[Therapist]
}
struct Therapist: Codable {
    let id:Double
    let therapistSince:Double
    let primaryLicense:String
    let name:String
    let shiftInfo: ShiftInfo
    
}
struct ShiftInfo:Codable {
    let start: Int
    let duration: Int
    
}
