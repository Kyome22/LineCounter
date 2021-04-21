//
//  main.swift
//  LineCounter
//
//  Created by ky0me22 on 2021/04/21.
//

import Foundation

guard CommandLine.arguments.count == 2 else {
    print("usage: lc [absolute path of a file]")
    exit(1)
}

let fileUrl = URL(fileURLWithPath: CommandLine.arguments[1])
guard let file = try? String(contentsOf: fileUrl, encoding: .utf8) else {
    print("Error: could not read \(fileUrl.absoluteString)")
    exit(2)
}

print(file.components(separatedBy: CharacterSet.newlines).count)
