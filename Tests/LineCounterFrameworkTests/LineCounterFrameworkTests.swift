import XCTest
@testable import LineCounterFramework

final class LineCounterFrameworkTests: XCTestCase {

    func testMain() {
        Swift.print("hello")
        XCTAssertTrue(true)
    }
    
//    var rootPath: String {
//        return URL(fileURLWithPath: #file).path.components(separatedBy: "Tests/").first!
//    }
//
//    func testNoArguments() {
//        XCTAssertThrowsError(try resolveArgs(args: [])) { error in
//            XCTAssertEqual(error as? LCError, LCError.invalidOptions)
//        }
//    }
//
//    func testHelp() {
//        XCTAssertThrowsError(try resolveArgs(args: ["-h"])) { error in
//            XCTAssertEqual(error as? LCError, LCError.help)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["--help"])) { error in
//            XCTAssertEqual(error as? LCError, LCError.help)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["-h", "-p"])) { error in
//            XCTAssertEqual(error as? LCError, LCError.help)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["--help", "-p", "./", "-e", "swift"])) { error in
//            XCTAssertEqual(error as? LCError, LCError.help)
//        }
//    }
//
//    func testInvalidOptions() {
//        XCTAssertThrowsError(try resolveArgs(args: ["-a"]), "存在しないオプションは使えない") { error in
//            XCTAssertEqual(error as? LCError, LCError.invalidOptions)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["-p"]), "具体的なパスが指定されていない") { error in
//            XCTAssertEqual(error as? LCError, LCError.invalidOptions)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["-e", "swift"]), "パスは必ず指定する必要がある") { error in
//            XCTAssertEqual(error as? LCError, LCError.invalidOptions)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["-p", "./", "-e"]), "具体的な拡張子が指定されていない") { error in
//            XCTAssertEqual(error as? LCError, LCError.invalidOptions)
//        }
//
//        XCTAssertThrowsError(try resolveArgs(args: ["-p", "./", "./src/"]), "パスはオプション１つにつき１個まで") { error in
//            XCTAssertEqual(error as? LCError, LCError.invalidOptions)
//        }
//    }
//
//    func testSinglePath() throws {
//        let (paths, _) = try resolveArgs(args: ["-p", "./"])
//        XCTAssertEqual(paths.count, 1)
//        XCTAssertEqual(paths[0], "./")
//
//        let (paths2, _) = try resolveArgs(args: ["--path", "./"])
//        XCTAssertEqual(paths2.count, 1)
//        XCTAssertEqual(paths2[0], "./")
//    }
//
//    func testMultiplePaths() throws {
//        let (paths, _) = try resolveArgs(args: ["-p", "./", "--path", "../src"])
//        XCTAssertEqual(paths.count, 2)
//        XCTAssertEqual(paths[0], "./")
//        XCTAssertEqual(paths[1], "../src")
//    }
//
//    func testExtension() throws {
//        let (_, ext) = try resolveArgs(args: ["-p", "./", "-e", "swift"])
//        XCTAssertEqual(ext, "swift")
//
//        let (_, ext2) = try resolveArgs(args: ["-p", "./", "-e", "swift", "-e", "cpp"])
//        XCTAssertEqual(ext2, "cpp")
//    }
//
//    func testEnumerateFileURLs() {
//        let url = URL(fileURLWithPath: "\(rootPath)/Sources/")
//        let fileURLs = enumerateFileURLs(fileURL: url)
//        let sut = fileURLs.map { url -> String in
//            let components = url.pathComponents
//            return components[components.count - 2 ..< components.count].joined(separator: "/")
//        }.sorted()
//        let expect = [
//            "LineCounter/main.swift",
//            "LineCounterLibrary/LCError.swift",
//            "LineCounterLibrary/LCFoundation.swift"
//        ]
//        XCTAssertEqual(sut, expect)
//    }
//
//    func testCountLineSkip() {
//        let url = URL(fileURLWithPath: "main.cpp")
//        XCTAssertThrowsError(try countLine(with: url, ext: "swift"), "拡張子が一致しなければスキップ") { error in
//            XCTAssertEqual(error as? LCError, LCError.skip)
//        }
//    }
//
//    func testCountLineCouldNotRead() {
//        let url = URL(fileURLWithPath: "hoge.swift")
//        XCTAssertThrowsError(try countLine(with: url, ext: nil), "ファイルを読み込めなければエラー") { error in
//            XCTAssertEqual(error as? LCError, LCError.couldNotRead)
//        }
//    }
//
//    func testCountLine() throws {
//        let url = URL(fileURLWithPath: "\(rootPath)/Sources/LineCounter/main.swift")
//        let cnt = try countLine(with: url, ext: "swift")
//        XCTAssertGreaterThan(cnt, 0)
//    }
//
//    func testOutput() {
//        let urls = [
//            URL(fileURLWithPath: "\(rootPath)/Sources/LineCounter/main.swift"),
//            URL(fileURLWithPath: "\(rootPath)/Sources/LineCounterLibrary/LCError.swift"),
//            URL(fileURLWithPath: "\(rootPath)/Sources/LineCounterLibrary/LCFoundation.swift")
//        ]
//        let sut = output(fileURLs: urls, ext: "swift")
//        let cnt = sut.components(separatedBy: CharacterSet.newlines).count
//        XCTAssertEqual(cnt, 4)
//    }
//
//    static var allTests = [
//        ("testNoArguments", testNoArguments),
//        ("testHelp", testHelp),
//        ("testInvalidOptions", testInvalidOptions),
//        ("testSinglePath", testSinglePath),
//        ("testMultiplePaths", testMultiplePaths),
//        ("testExtension", testExtension),
//        ("testEnumerateFileURLs", testEnumerateFileURLs),
//        ("testCountLineSkip", testCountLineSkip),
//        ("testCountLineCouldNotRead", testCountLineCouldNotRead),
//        ("testCountLine", testCountLine),
//        ("testOutput", testOutput),
//    ]
}
