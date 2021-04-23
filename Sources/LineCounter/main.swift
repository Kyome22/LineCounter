//
//  main.swift
//  LineCounter
//
//  Created by ky0me22 on 2021/04/21.
//

import Foundation

do {
    let (rootPath, ext) = try resolveArgs()
    let fileURLs = enumerateFileURLs(fileURL: URL(fileURLWithPath: rootPath))
    output(fileURLs: fileURLs, ext: ext)
} catch {
    switch error {
    case LCError.help:
        exitWithManual(0)
    case LCError.invalidOptions:
        exitWithManual(1)
    default:
        break
    }
}

