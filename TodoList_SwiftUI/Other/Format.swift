//
//  Format.swift
//  TodoList_SwiftUI
//
//  Created by 土橋正晴 on 2020/06/03.
//  Copyright © 2020 m.dobashi. All rights reserved.
//

import Foundation

/// Dateにフォーマットを設定する
struct Format {
    
    /// フォーマットを返す
    /// - Parameter addSec: 秒数もフォーマットに設定するかの判定
    private static func _dateFormatter(addSec: SecndType = .None) -> DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        switch addSec {
        case .secnd:
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        case .ms:
            formatter.dateFormat = "yyyy/MM/dd HH:mm:SSSS"
        default:
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
        }
        
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter
    }
    
    
    /// Stringのフォーマットを設定Dateを返す
    static func dateFromString(string: String, addSec: SecndType = .None) -> Date? {
        let formatter: DateFormatter = _dateFormatter(addSec: addSec)
        return formatter.date(from: string)
    }
    
    
    /// Dateのフォーマットを設定しStringを返す
    static func stringFromDate(date: Date, addSec: SecndType = .None) -> String {
        let formatter = _dateFormatter(addSec: addSec)
        let s_Date:String = formatter.string(from: date)
        
        return s_Date
    }
    
    
    /// 現在時間をのフォーマットを設定して返す
    static func dateFormat(addSec: SecndType = .None) -> Date {
        let formatter = Format._dateFormatter(addSec: addSec)
        let s_Date:String = formatter.string(from: Date())
        
        return formatter.date(from: s_Date)!
    }
    
    
    
    enum SecndType {
        case secnd
        case ms
        case None
    }
}
