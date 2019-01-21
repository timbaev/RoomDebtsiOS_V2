//
//  Log.swift
//  ITISService
//
//  Created by Тимур Шафигуллин on 02/11/2018.
//  Copyright © 2018 Timur Shafigullin. All rights reserved.
//

import Foundation

enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

/// Wrapping Swift.print() within DEBUG flag
func print(_ object: Any) {
    #if DEBUG
        Swift.print(object)
    #endif
}

class Log {
    
    static var dateFormat = "hh:mm:ss"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func e(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        printLog(object, filename: filename, line: line, column: column, funcName: funcName, event: LogEvent.e)
    }
    
    class func d(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        printLog(object, filename: filename, line: line, column: column, funcName: funcName, event: LogEvent.d)
    }
    
    class func i(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        printLog(object, filename: filename, line: line, column: column, funcName: funcName, event: LogEvent.i)
    }
    
    class func v(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        printLog(object, filename: filename, line: line, column: column, funcName: funcName, event: LogEvent.v)
    }
    
    class func w(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        printLog(object, filename: filename, line: line, column: column, funcName: funcName, event: LogEvent.w)
    }
    
    class func s(_ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        printLog(object, filename: filename, line: line, column: column, funcName: funcName, event: LogEvent.s)
    }
    
    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
    
    private class func printLog(_ object: Any, filename: String, line: Int, column: Int, funcName: String, event: LogEvent) {
        if isLoggingEnabled {
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)")
        }
    }
    
}

fileprivate extension Date {
    
    func toString() -> String {
        return Log.dateFormatter.string(from: self)
    }
    
}
