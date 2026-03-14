//
//  OSLog+Extensions.swift
//  Chaser
//
//  Created by GitHub Copilot
//

import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let app = Logger(subsystem: subsystem, category: "app")
    static let parsing = Logger(subsystem: subsystem, category: "parsing")
    static let storage = Logger(subsystem: subsystem, category: "storage")
    static let ui = Logger(subsystem: subsystem, category: "ui")
    static let iap = Logger(subsystem: subsystem, category: "iap")
}
