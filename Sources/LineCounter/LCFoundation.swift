//
//  File.swift
//  
//
//  Created by ky0me22 on 2021/04/23.
//

import Foundation

func exitWithManual(_ num: Int32) -> Never {
    let manual = """
    Usage:
      lc [-p <path>] [-e <extension>]
      lc [-h | --help]

    Options:

      -p, --path PATH            Specify an absolute path for the file or directory

      -e, --extension EXTENSION  Specify a file extension for which you want to
                                 count the number of lines
    """
    print(manual)
    exit(num)
}

func resolveArgs() throws -> (rootPath: String, ext: String?) {
    var args = CommandLine.arguments
    args.removeFirst()
    if args.contains(where: { $0 == "-h" || $0 == "--help" }) {
        throw LCError.help
    }
    var path: String?
    var ext: String?
    for i in stride(from: 0, to: args.count, by: 2) {
        switch args[i] {
        case "-p", "--path":
            if i + 1 < args.count {
                path = args[i + 1]
            }
        case "-e", "--extension":
            if i + 1 < args.count {
                ext = args[i + 1]
            } else {
                throw LCError.invalidOptions
            }
        default:
            throw LCError.invalidOptions
        }
    }
    if let rootPath = path {
        return (rootPath, ext)
    }
    throw LCError.invalidOptions
}

func enumerateFileURLs(fileURL: URL) -> [URL] {
    let fileManager = FileManager.default
    var isDirectory: ObjCBool = false
    if fileManager.fileExists(atPath: fileURL.path, isDirectory: &isDirectory) {
        if isDirectory.boolValue  {
            if let contents = try? fileManager.contentsOfDirectory(atPath: fileURL.path) {
                return contents.flatMap {
                    enumerateFileURLs(fileURL: fileURL.appendingPathComponent($0))
                }
            }
        } else {
            return [fileURL]
        }
    }
    return []
}

func countLine(with fileURL: URL, ext: String?) throws -> Int {
    if let pathExtension = ext, fileURL.pathExtension != pathExtension {
        throw LCError.skip
    }
    guard let file = try? String(contentsOf: fileURL, encoding: .utf8) else {
        throw LCError.couldNotRead
    }
    return file.components(separatedBy: CharacterSet.newlines).count
}

func output(fileURLs: [URL], ext: String?) {
    var total: Int = 0
    fileURLs.forEach { (fileURL) in
        do {
            let cnt: Int = try countLine(with: fileURL, ext: ext)
            print("\(fileURL.path): \(cnt)")
            total += cnt
        } catch LCError.couldNotRead {
            print("\(fileURL.path): could not read")
        } catch {
            // skip
        }
    }
    print("\nTotal: \(total)")
}
