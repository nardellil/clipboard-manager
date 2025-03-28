//
//  DateUtil.swift
//  clipboard-manager
//
//  Created by Luca Nardelli on 28/03/25.
//

import Foundation

struct DateUtil {
    static func formatRelativeDate(from timestamp: Int) -> String {
        if timestamp == 0 {
            return ""
        }
        let calendar = Calendar.current
        let now = Date()
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))

        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let components = calendar.dateComponents([.year, .month, .day], from: date, to: now)

            if let year = components.year, year > 0 {
                return year == 1 ? "1 year ago" : "\(year) years ago"
            } else if let month = components.month, month > 0 {
                return month == 1 ? "1 month ago" : "\(month) months ago"
            } else if let day = components.day, day > 0 {
                return day == 1 ? "1 day ago" : "\(day) days ago"
            } else {
                return "Just now"
            }
        }
    }
}
