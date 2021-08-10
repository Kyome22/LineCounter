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

func resolveArgs(args: [String]) throws -> (paths: [String], ext: String?) {
    if args.contains(where: { $0 == "-h" || $0 == "--help" }) {
        throw LCError.help
    }
    var paths = [String]()
    var ext: String?
    for i in stride(from: 0, to: args.count, by: 2) {
        switch args[i] {
        case "-p", "--path":
            if i + 1 < args.count {
                paths.append(args[i + 1])
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
    if !paths.isEmpty {
        return (paths, ext)
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

func output(fileURLs: [URL], ext: String?) -> String {
    var result: String = ""
    var total: Int = 0
    fileURLs.forEach { (fileURL) in
        do {
            let cnt: Int = try countLine(with: fileURL, ext: ext)
            result += "\t\(cnt)\t\(fileURL.path)\n"
            total += cnt
        } catch LCError.couldNotRead {
            result += "\tCould not read\t\(fileURL.path)\n"
        } catch {
            // skip
        }
    }
    result += "Total: \(total)"
    return result
}

public func run(arguments: [String]) {
    do {
        let (paths, ext) = try resolveArgs(args: arguments)
        let fileURLs = paths.flatMap { path -> [URL] in
            let url = URL(fileURLWithPath: path)
            return enumerateFileURLs(fileURL: url)
        }
        let result = output(fileURLs: fileURLs, ext: ext)
        print(result)
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
}
