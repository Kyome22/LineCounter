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
