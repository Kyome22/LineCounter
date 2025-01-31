@testable import LineCounterFramework

import Foundation
import Testing

struct LineCounterFrameworkTests {
    private var sourcesURL: URL {
        guard let url = Bundle.module.resourceURL?.appending(path: "Sources") else {
            fatalError("Failed to get Sources directory url.")
        }
        return url
    }

    @Test
    func enumerate_file_paths() {
        let sut = LineCounter()
        let actual = sut.enumerateFilePaths(url: sourcesURL)
            .map { $0.pathComponents.suffix(2).joined(separator: "/") }
            .sorted()
        let expect = [
            "LineCounterFramework/LCError.swift",
            "LineCounterFramework/LCVersion.swift",
            "LineCounterFramework/LineCounter.swift",
            "lc/LC.swift",
            "lc/main.swift",
        ]
        #expect(actual == expect)
    }

    @Test
    func count_line_without_file_extension() throws {
        let sut = LineCounter()
        let mainFileURL = sourcesURL.appendingPathComponent("lc/main.swift")
        let actual = try sut.countLine(mainFileURL, [])
        #expect(actual == 9)
    }

    @Test
    func count_line_with_file_extension() throws {
        let sut = LineCounter()
        let mainFileURL = sourcesURL.appendingPathComponent("lc/main.swift")
        let actual = try sut.countLine(mainFileURL, ["swift"])
        #expect(actual == 9)
    }

    @Test
    func count_line_throw_LCErrorSkipped() {
        let sut = LineCounter()
        let mainFileURL = sourcesURL.appendingPathComponent("lc/main.swift")
        #expect(throws: LCError.skipped(file: "")) {
            try sut.countLine(mainFileURL, ["txt"])
        }
    }

    @Test
    func count_line_throw_LCErrorCouldNotRead() {
        let sut = LineCounter()
        let dummyFileURL = sourcesURL.appendingPathComponent("lc/dummy.swift")
        #expect(throws: LCError.couldNotRead(file: "")) {
            try sut.countLine(dummyFileURL, [])
        }
    }

    @Test
    func output_single_path() {
        let sut = LineCounter()
        let filePaths = [sourcesURL.appendingPathComponent("lc/LC.swift")]
        let actual = sut.output(filePaths, ["swift"], true)
        let lines = actual.components(separatedBy: CharacterSet.newlines).count
        #expect(lines == 1)
    }

    @Test
    func output_multi_paths() {
        let sut = LineCounter()
        let sourcesURL = sourcesURL
        let filePaths = [
            sourcesURL.appendingPathComponent("lc/LC.swift"),
            sourcesURL.appendingPathComponent("lc/main.swift"),
        ]
        let actual = sut.output(filePaths, ["swift"], true)
        let lines = actual.components(separatedBy: CharacterSet.newlines).count
        #expect(lines == 4)
    }
}
