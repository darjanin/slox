// The Swift Programming Language
// https://docs.swift.org/swift-book


import ArgumentParser

@main
struct App: ParsableCommand {
    @Argument(help: "The script to run")
    var script: String?
    
    mutating func run() throws {
        if let script = script {
            try Slox.runFile(script)
        } else {
            Slox.runPrompt()
        }
    }
}
