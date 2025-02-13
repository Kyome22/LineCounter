/*
 LineCounter.swift

 Created by ky0me22 on 2021/04/21.
*/

import Foundation

public struct LineCounter {
    var paths: [String]
    var extensions: [String]
    var noWarnings: Bool

    public init(paths: [String], extensions: [String], noWarnings: Bool) {
        self.paths = paths
        self.extensions = extensions
        self.noWarnings = noWarnings
    }

    func enumerateFileURLs(url: URL) -> [URL] {
        let fm = FileManager.default
        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: url.absoluteURL.path(), isDirectory: &isDirectory) else {
            return []
        }
        guard isDirectory.boolValue else {
            return [url]
        }
        guard let contents = try? fm.contentsOfDirectory(atPath: url.absoluteURL.path()) else {
            return []
        }
        return contents.flatMap { content in
            enumerateFileURLs(url: url.appendingPathComponent(content))
        }
    }

    func count(fileURL: URL) -> Result<Int, CountError> {
        guard extensions.isEmpty || extensions.contains(fileURL.pathExtension) else {
            return .failure(.skipped(fileURL.path()))
        }
        guard let file = try? String(contentsOf: fileURL, encoding: .utf8) else {
            return .failure(.failedToRead(fileURL.path()))
        }
        let count = file.components(separatedBy: CharacterSet.newlines).count
        return .success(count)
    }

    func output(fileURLs: [URL]) -> String {
        guard !fileURLs.isEmpty else {
            return "⚠️ No files found."
        }
        let output = fileURLs.reduce(into: Output()) { partialResult, fileURL in
            switch count(fileURL: fileURL) {
            case let .success(count):
                partialResult.rows.append("\t\(count)\t\(fileURL.path())")
                partialResult.totalCount += count
                partialResult.filesCount += 1
            case let .failure(error):
                guard !noWarnings else { return }
                switch error {
                case let .skipped(filePath):
                    partialResult.rows.append("\tSkipped\t\(filePath)")
                case let .failedToRead(filePath):
                    partialResult.rows.append("\tCould not read\t\(filePath)")
                }
            }
        }
        guard 1 < output.rows.count else {
            return output.rows.joined(separator: "\n")
        }
        let unit = output.filesCount > 1 ? "files" : "file"
        return """
            🎯 Result of LineCounter
            \(output.rows.joined(separator: "\n"))
            Total: \(output.totalCount) (\(output.filesCount) \(unit))
            """
    }

    public func run() {
        let fileURLs = paths.flatMap { path in
            enumerateFileURLs(url: URL(fileURLWithPath: path))
        }
        Swift.print(output(fileURLs: fileURLs))
    }
}
