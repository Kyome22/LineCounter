//
//  LCError.swift
//  
//
//  Created by ky0me22 on 2022/03/11.
//

import Foundation

enum LCError: Error {
    case couldNotRead(file: String)
    case skipped(file: String)
}

extension LCError: Equatable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.couldNotRead(_), .couldNotRead(_)):
            return true
        case (.skipped(_), .skipped(_)):
            return true
        default:
            return false
        }
    }
}
