import Foundation

class BashRunner: ObservableObject {
    @Published var output: String = ""
    @Published var isRunning = false
    
    private var process: Process?
    private var outputPipe: Pipe?
    private var errorPipe: Pipe?
    
    func run(_ command: String, arguments: [String] = []) async throws -> Int32 {
        guard !command.isEmpty else {
            throw BashError.invalidCommand
        }
        
        isRunning = true
        output = ""
        
        let process = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        
        process.executableURL = URL(fileURLWithPath: command)
        process.arguments = arguments
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        self.process = process
        self.outputPipe = outputPipe
        self.errorPipe = errorPipe
        
        outputPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let data = try? handle.read(upToCount: 1024),
                  let output = String(data: data, encoding: .utf8) else { return }
            
            DispatchQueue.main.async {
                self?.output += output
            }
        }
        
        errorPipe.fileHandleForReading.readabilityHandler = { [weak self] handle in
            guard let data = try? handle.read(upToCount: 1024),
                  let output = String(data: data, encoding: .utf8) else { return }
            
            DispatchQueue.main.async {
                self?.output += "Error: " + output
            }
        }
        
        try process.run()
        process.waitUntilExit()
        
        outputPipe.fileHandleForReading.readabilityHandler = nil
        errorPipe.fileHandleForReading.readabilityHandler = nil
        
        isRunning = false
        return process.terminationStatus
    }
    
    func terminate() {
        process?.terminate()
    }
}

enum BashError: Error {
    case invalidCommand
    
    var localizedDescription: String {
        switch self {
        case .invalidCommand:
            return "Invalid command provided"
        }
    }
}