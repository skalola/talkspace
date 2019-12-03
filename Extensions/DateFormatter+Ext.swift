//
//  DateFormatter+Ext.swift
//  iOS Interview
//
//  Created by Maxim Eremenko on 03.12.2019.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    static let dateStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter
    }()
    
    static let timeStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
}

extension DateComponentsFormatter {
    
    static let abbreviatedStyle: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
}
