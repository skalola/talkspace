//
//  Therapist.swift
//  iOS Interview
//
//  Created by Shiv Kalola on 11/6/19.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation
import UIKit


struct Therapist: Decodable {
    var id: Int
    var therapistSince: Int
    var primaryLicense: String
    var name: String
    var start: Int
    var duration: Int

    init(id: Int, therapistSince: Int, primaryLicense: String, name: String, start: Int, duration: Int) {
        self.id = id
        self.therapistSince = therapistSince
        self.primaryLicense = primaryLicense
        self.name = name
        self.start = start
        self.duration = duration
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id",
        therapistSince = "therapistSince",
        primaryLicense = "primaryLicense",
        name = "name",
        start = "start",
        duration = "duration"
    }
    
    enum status {
        case allTherapist
        case activeTherapist
        case noTherapist
    }
}





