import XCTest
@testable import LineCounterFramework

final class LineCounterFrameworkTests: XCTestCase {
    var rootPath: String {
        return URL(fileURLWithPath: #file).path.components(separatedBy: "Tests/").first!
    }
    
    var srcURL: URL {
        return URL(fileURLWithPath: "\(rootPath)Sources/")
    }
    
    func testRootPath() {
        Swift.print("🎯", srcURL.path)
    }
    
    func testEnumerateFilePaths() {
        let sut = LineCounter()
        let actual = sut.enumerateFilePaths(url: srcURL)
            .map { url -> String in
                let components = url.pathComponents
                return components[components.count - 2..<components.count]
                    .joined(separator: "/")
            }
            .sorted()
        let expect = [
            "LineCounterFramework/LCError.swift",
            "LineCounterFramework/LCVersion.swift",
            "LineCounterFramework/LineCounter.swift",
            "lc/LC.swift",
            "lc/main.swift",
        ]
        XCTAssertEqual(actual, expect)
    }
    
    func testCountLine() throws {
        let sut = LineCounter()
        let mainFileURL = srcURL.appendingPathComponent("lc/main.swift")
        let actual1 = try sut.countLine(mainFileURL, [])
        XCTAssertEqual(actual1, 9)
        let actual2 = try sut.countLine(mainFileURL, ["swift"])
        XCTAssertEqual(actual2, 9)
    }
    
    func testCountLineThrowLCErrorSkipped() {
        let sut = LineCounter()
        let mainFileURL = srcURL.appendingPathComponent("lc/main.swift")
        XCTAssertThrowsError(try sut.countLine(mainFileURL, ["txt"])) { error in
            XCTAssertEqual(error as? LCError, LCError.skipped(file: ""))
        }
    }
    
    func testCountLineThrowLCErrorCouldNotRead() {
        let sut = LineCounter()
        let dummyFileURL = srcURL.appendingPathComponent("lc/dummy.swift")
        XCTAssertThrowsError(try sut.countLine(dummyFileURL, [])) { error in
            XCTAssertEqual(error as? LCError, LCError.couldNotRead(file: ""))
        }
    }
    
    func testOutputSinglePath() {
        let sut = LineCounter()
        let filePaths = [srcURL.appendingPathComponent("lc/LC.swift")]
        let actual = sut.output(filePaths, ["swift"], true)
        Swift.print(actual)
        let lines = actual.components(separatedBy: CharacterSet.newlines).count
        XCTAssertEqual(lines, 1)
    }

    func testOutputMultiPaths() {
        let sut = LineCounter()
        let filePaths = [
            srcURL.appendingPathComponent("lc/LC.swift"),
            srcURL.appendingPathComponent("lc/main.swift"),
        ]
        let actual = sut.output(filePaths, ["swift"], true)
        Swift.print(actual)
        let lines = actual.components(separatedBy: CharacterSet.newlines).count
        XCTAssertEqual(lines, 4)
    }
}
