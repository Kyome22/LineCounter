/*
 LC.swift

 Created by ky0me22 on 2022/03/11.
*/

import ArgumentParser
import LineCounterFramework

struct LC: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "lc",
        abstract: "A tool to count the number of lines in the specified file.",
        version: "1.3.0"
    )
    
    @Option(
        wrappedValue: ["./"],
        name: [.customShort("p"), .customLong("path")],
        parsing: ArrayParsingStrategy.singleValue,
        help: "The path to the file or directory to count lines."
    )
    var paths: [String]
    
    @Option(
        wrappedValue: [],
        name: [.customShort("e"), .customLong("extension")],
        parsing: ArrayParsingStrategy.singleValue,
        help: "The extension of the file you want to count lines."
    )
    var extensions: [String]
    
    @Flag(help: "Do not output warnings.")
    var noWarnings: Bool = false
    
    mutating func run() throws {
        LineCounter(paths: paths, extensions: extensions, noWarnings: noWarnings).run()
    }
}
