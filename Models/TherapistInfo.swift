//
//  TherapistInfo.swift
//  iOS Interview
//
//  Created by Maxim Eremenko on 03.12.2019.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation

struct TherapistInfo: Decodable {
    
    let therapists: [Therapist]
    
    static func make() throws -> TherapistInfo {
        guard let url = Bundle.main.url(forResource: "therapists09",
                                        withExtension: "json") else {
            throw CreationError.fileNotExist
        }
        let data = try Data(contentsOf: url)
        
        return try JSONDecoder().decode(TherapistInfo.self, from: data)
    }
    
    private enum CreationError: Error {
        case fileNotExist
    }
}
