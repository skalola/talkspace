//
//  ListViewModel.swift
//  iOS Interview
//
//  Created by Maxim Eremenko on 03.12.2019.
//  Copyright © 2019 Talkspace. All rights reserved.
//

import Foundation

struct ListViewModel {
    
    private let items: [Therapist]
    private let originDate: Date
    
    private(set) var filterItems: [Item]
    var sorting: Sorting = .byGap {
        didSet {
            filterItems = Self.filter(items, originDate, sorting)
        }
    }
    
    init(items: [Therapist], originDate: Date) {
        self.items = items
        self.originDate = originDate
        filterItems = Self.filter(items, originDate, sorting)
    }
    
    private static func filter(_ items: [Therapist], _ originDate: Date, _ sorting: Sorting) -> [Item] {
        
        let sorted = items.sort(by: sorting, originDate)
        var result = sorted.map { Item.data(DataItem.make($0, originDate))}
        
        for idx in stride(from: sorted.count - 1, through: 1, by: -1) {
            let current = sorted[idx]
            let previous = sorted[idx - 1]
            
            if current.info.end < previous.info.start {
                let item = EmptyItem.make(originDate,
                                          TimeInterval(previous.info.end),
                                          TimeInterval(current.info.start))
                result.insert(.empty(item), at: idx)
            }
        }
        
        return result.filter(using: sorting)
    }
}

extension ListViewModel {
    
    enum Item {
        case data(_ item: DataItem)
        case empty(_ item: EmptyItem)
        
        var isEmpty: Bool {
            switch self {
            case .data: return false
            case .empty: return true
            }
        }
    }
    
    struct DataItem {
        let name: String
        let pHdSince: String!
        let onDuty: String
    }
    
    struct EmptyItem {
        let title: String
        
        static func make(_ originDate: Date, _ from: TimeInterval, _ to: TimeInterval) -> EmptyItem {
            let fromTime = DateFormatter.timeStyle.string(
                from: originDate.startOfDay.addingTimeInterval(from)
            )
            let toTime = DateFormatter.timeStyle.string(
                from: originDate.startOfDay.addingTimeInterval(to)
            )
            return EmptyItem(title: "No Therapist: \(fromTime) to \(toTime)")
        }
    }
    
    enum Sorting {
        case byGap
        case byDuty
        case byStartingDate
    }
}

extension ListViewModel.DataItem {
    
    static func make(_ item: Therapist, _ originDate: Date) -> ListViewModel.DataItem {
        return .init(name: makeName(item),
                     pHdSince: makePhdTitle(item),
                     onDuty: makeOnDutyTitle(item, originDate))
    }
    
    private static func makeName(_ item: Therapist) -> String {
        // Get last name
        let split = item.name.split(separator: " ")
        return String(split.suffix(1).joined(separator: [" "]))
    }
    
    private static func makePhdTitle(_ item: Therapist) -> String {
        // Get primary license string and therapistSince date
        let time = item.therapistSince
        let date = Date(timeIntervalSince1970: Double(time))
        let strDate = DateFormatter.dateStyle.string(from: date)
        return item.primaryLicense + " since " + strDate
    }
    
    private static func makeOnDutyTitle(_ item: Therapist, _ originDate: Date) -> String {
        
        // Calculate shift times
        let startTime = originDate.startOfDay.addingTimeInterval(TimeInterval(item.info.start))
        let formattedStartTime = DateFormatter.timeStyle.string(from: startTime)
        let endTime = startTime.addingTimeInterval(TimeInterval(item.info.duration))
        let formattedEndTime = DateFormatter.timeStyle.string(from: endTime)
        var result = "On Duty: " + formattedStartTime + " to " + formattedEndTime + ". "
        
        let formattedString = DateComponentsFormatter.abbreviatedStyle.string(
            from: TimeInterval(Double(item.info.duration))
            )!
        if startTime < originDate && originDate < endTime {
            result += " \(formattedString) till end"
        }
        
        // Calculate time left til shift starts
        if originDate < startTime {
            let timeDifference = Calendar.current.dateComponents(
                [.hour, .minute], from: startTime, to: originDate
            )
            result += "\(timeDifference.hour!)hr \(timeDifference.minute!)min till start"
        }
        return result
    }
}

private extension Array where Element == Therapist {
    
    func sort(by item: ListViewModel.Sorting, _ originDate: Date) -> [Element] {
        switch item {
        case .byGap:
            return self
        case .byDuty:
            return sortByDuty(originDate)
        case .byStartingDate:
            return sortbyStartingDate(originDate)
        }
    }
    
    private func sortByDuty(_ originDate: Date) -> [Therapist] {
        let time = originDate.timeSinceStartOfDay
        return filter {
            time > TimeInterval($0.info.start) && time < TimeInterval($0.info.end)
        }
    }
    
    private func sortbyStartingDate(_ originDate: Date) -> [Therapist] {
        let time = originDate.timeSinceStartOfDay
        return filter {
            time < TimeInterval($0.info.start) && time < TimeInterval($0.info.end)
        }
    }
}

private extension Array where Element == ListViewModel.Item {
    
    func filter(using sorting: ListViewModel.Sorting) -> [Element] {
        switch sorting {
        case .byGap:
            return filter { $0.isEmpty }
        case .byDuty:
            return self
        case .byStartingDate:
            return self
        }
    }
}

private extension Date {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var timeSinceStartOfDay: TimeInterval {
        timeIntervalSince(startOfDay)
    }
}
