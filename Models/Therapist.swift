//
//  Therapist.swift
//  iOS Interview
//
//  Created by Shiv Kalola on 11/6/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation

struct Therapist: Decodable {
    let id: Int
    let therapistSince: Int
    let primaryLicense: String
    let name: String
    let info: ShiftInfo
    
    struct ShiftInfo: Decodable {
        let start: Int
        let duration: Int
        
        var end: Int {
            return start + duration
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case therapistSince
        case primaryLicense
        case name
        case info = "shiftInfo"
    }
}
