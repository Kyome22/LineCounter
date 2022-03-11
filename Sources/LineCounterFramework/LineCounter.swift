//
//  LineCounter.swift
//
//
//  Created by ky0me22 on 2021/04/21.
//

import Foundation

public struct LineCounter {
    public static func run(paths: [String], ext: String?, noWarnings: Bool) {
        let lc = LineCounter()
        let filePaths = paths.flatMap { path -> [URL] in
            lc.enumerateFilePaths(filePath: URL(fileURLWithPath: path))
        }
        if filePaths.isEmpty {
            Swift.print("There was no file to read.")
        } else {
            let output = lc.output(filePaths: filePaths,
                                   ext: ext,
                                   noWarnings: noWarnings)
            Swift.print(output)
        }
    }
    
    func enumerateFilePaths(filePath: URL) -> [URL] {
        let fm = FileManager.default
        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: filePath.path, isDirectory: &isDirectory) else {
            return []
        }
        if isDirectory.boolValue {
            guard let contents = try? fm.contentsOfDirectory(atPath: filePath.path) else {
                return []
            }
            return contents.flatMap { content in
                enumerateFilePaths(filePath: filePath.appendingPathComponent(content))
            }
        } else {
            return [filePath]
        }
    }
    
    func countLine(with filePath: URL, ext: String?) throws -> Int {
        if let ext = ext, filePath.pathExtension != ext {
            throw LCError.skipped(file: filePath.relativePath)
        }
        guard let file = try? String(contentsOf: filePath, encoding: .utf8) else {
            throw LCError.couldNotRead(file: filePath.relativePath)
        }
        return file.components(separatedBy: CharacterSet.newlines).count
    }
    
    func output(filePaths: [URL], ext: String?, noWarnings: Bool) -> String {
        var result: String = ""
        var total: Int = 0
        filePaths.forEach { filePath in
            do {
                let count: Int = try countLine(with: filePath, ext: ext)
                result += "\t\(count)\t\(filePath.relativePath)\n"
                total += count
            } catch let lcError as LCError {
                if noWarnings {
                    return
                }
                switch lcError {
                case let .couldNotRead(file):
                    result += "\tCouldn’t read\t\(file)\n"
                case let .skipped(file):
                    result += "\tSkipped\t\(file)\n"
                }
            } catch {
                fatalError("Oops, impossible error.")
            }
        }
        result += "Total: \(total)"
        return result
    }
}
