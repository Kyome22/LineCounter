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
    func enumerate_file_urls() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let actual = sut.enumerateFileURLs(url: sourcesURL)
            .map { $0.pathComponents.suffix(2).joined(separator: "/") }
            .sorted()
        let expect = [
            "LineCounterFramework/CountError.swift",
            "LineCounterFramework/LineCounter.swift",
            "LineCounterFramework/Output.swift",
            "lc/LC.swift",
            "lc/main.swift",
        ]
        #expect(actual == expect)
    }

    @Test
    func count_without_file_extension() throws {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let mainFileURL = sourcesURL.appendingPathComponent("lc/main.swift")
        let actual = try sut.count(fileURL: mainFileURL).get()
        #expect(actual == 8)
    }

    @Test
    func count_with_matched_file_extension() throws {
        let sut = LineCounter(paths: [], extensions: ["swift"], noWarnings: false)
        let mainFileURL = sourcesURL.appendingPathComponent("lc/main.swift")
        let actual = try sut.count(fileURL: mainFileURL).get()
        #expect(actual == 8)
    }

    @Test
    func count_with_not_matched_file_extension() {
        let sut = LineCounter(paths: [], extensions: ["txt"], noWarnings: false)
        let mainFileURL = sourcesURL.appendingPathComponent("lc/main.swift")
        #expect(throws: CountError.skipped("Contents/Resources/Sources/lc/main.swift")) {
            try sut.count(fileURL: mainFileURL).get()
        }
    }

    @Test
    func count_with_invalid_file() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let dummyFileURL = sourcesURL.appendingPathComponent("lc/dummy.swift")
        #expect(throws: CountError.failedToRead("Contents/Resources/Sources/lc/dummy.swift")) {
            try sut.count(fileURL: dummyFileURL).get()
        }
    }

    @Test
    func output_no_files() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let actual = sut.output(fileURLs: [])
        #expect(actual == "⚠️ No files found.")
    }

    @Test
    func output_single_file() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let fileURLs = [sourcesURL.appendingPathComponent("lc/LC.swift")]
        let actual = sut.output(fileURLs: fileURLs)
        #expect(actual == "\t40\tContents/Resources/Sources/lc/LC.swift")
    }

    @Test
    func output_multi_files() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let sourcesURL = sourcesURL
        let fileURLs = [
            sourcesURL.appendingPathComponent("lc/LC.swift"),
            sourcesURL.appendingPathComponent("lc/main.swift"),
        ]
        let actual = sut.output(fileURLs: fileURLs)
        #expect(actual == """
            🎯 Result of LineCounter
            \t40\tContents/Resources/Sources/lc/LC.swift
            \t8\tContents/Resources/Sources/lc/main.swift
            Total: 48 (2 files)
            """)
    }

    @Test
    func output_multi_files_with_warning_skipped() {
        let sut = LineCounter(paths: [], extensions: ["swift"], noWarnings: false)
        let sourcesURL = sourcesURL
        let fileURLs = [
            sourcesURL.appendingPathComponent("lc/main.swift"),
            sourcesURL.appendingPathComponent("lc/dummy.txt"),
        ]
        let actual = sut.output(fileURLs: fileURLs)
        #expect(actual == """
            🎯 Result of LineCounter
            \t8\tContents/Resources/Sources/lc/main.swift
            \tSkipped\tContents/Resources/Sources/lc/dummy.txt
            Total: 8 (1 file)
            """)
    }

    @Test
    func output_multi_files_with_warning_failed_to_read() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: false)
        let sourcesURL = sourcesURL
        let fileURLs = [
            sourcesURL.appendingPathComponent("lc/main.swift"),
            sourcesURL.appendingPathComponent("lc/dummy.txt"),
        ]
        let actual = sut.output(fileURLs: fileURLs)
        #expect(actual == """
            🎯 Result of LineCounter
            \t8\tContents/Resources/Sources/lc/main.swift
            \tCould not read\tContents/Resources/Sources/lc/dummy.txt
            Total: 8 (1 file)
            """)
    }

    @Test
    func output_multi_files_without_warning() {
        let sut = LineCounter(paths: [], extensions: [], noWarnings: true)
        let sourcesURL = sourcesURL
        let fileURLs = [
            sourcesURL.appendingPathComponent("lc/LC.swift"),
            sourcesURL.appendingPathComponent("lc/main.swift"),
            sourcesURL.appendingPathComponent("lc/dummy.txt"),
        ]
        let actual = sut.output(fileURLs: fileURLs)
        #expect(actual == """
            🎯 Result of LineCounter
            \t40\tContents/Resources/Sources/lc/LC.swift
            \t8\tContents/Resources/Sources/lc/main.swift
            Total: 48 (2 files)
            """)
    }
}

extension CountError: Equatable {
    public static func == (lhs: CountError, rhs: CountError) -> Bool {
        switch (lhs, rhs) {
        case let (.skipped(l), .skipped(r)) where l == r:
            true
        case let (.failedToRead(l), .failedToRead(r)) where l == r:
            true
        default:
            false
        }
    }
}
