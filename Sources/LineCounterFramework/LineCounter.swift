//
//  LineCounter.swift
//
//
//  Created by ky0me22 on 2021/04/21.
//

import Foundation

public struct LineCounter {
    public static func run(paths: [String], extentions: [String], noWarnings: Bool) {
        let lc = LineCounter()
        let filePaths = paths.flatMap { path -> [URL] in
            lc.enumerateFilePaths(url: URL(fileURLWithPath: path))
        }
        if filePaths.isEmpty {
            Swift.print("⚠️ There was no file to read.")
        } else {
            Swift.print(lc.output(filePaths, extentions, noWarnings))
        }
    }
    
    func enumerateFilePaths(url: URL) -> [URL] {
        let fm = FileManager.default
        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return []
        }
        guard isDirectory.boolValue else {
            return [url]
        }
        guard let contents = try? fm.contentsOfDirectory(atPath: url.path) else {
            return []
        }
        return contents.flatMap { content in
            enumerateFilePaths(url: url.appendingPathComponent(content))
        }
    }
    
    func countLine(_ filePath: URL, _ extensions: [String]) throws -> Int {
        guard extensions.isEmpty || extensions.contains(filePath.pathExtension) else {
            throw LCError.skipped(file: filePath.relativePath)
        }
        guard let file = try? String(contentsOf: filePath, encoding: .utf8) else {
            throw LCError.couldNotRead(file: filePath.relativePath)
        }
        return file.components(separatedBy: CharacterSet.newlines).count
    }
    
    func output(_ filePaths: [URL], _ extensions: [String], _ noWarnings: Bool) -> String {
        var result: String = ""
        var fileCount: Int = 0
        var totalCount: Int = 0
        filePaths.forEach { filePath in
            do {
                let count: Int = try countLine(filePath, extensions)
                result += "\t\(count)\t\(filePath.relativePath)\n"
                fileCount += 1
                totalCount += count
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
        result = result.trimmingCharacters(in: .newlines)
        if 1 < fileCount {
            result = "🎯 Result of LineCounter\n\(result)\nTotal: \(totalCount) (\(fileCount) files)"
        }
        return result
    }
}
