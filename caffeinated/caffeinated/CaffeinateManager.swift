import Foundation

final class CaffeinateManager {
    private(set) var isActive = false
    private var process: Process?
    var onStateChange: (() -> Void)?

    func toggle() {
        isActive ? stop() : start()
    }

    func start() {
        guard !isActive else { return }
        
        let newProcess = Process()
        newProcess.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        newProcess.arguments = ["-d"]
        
        newProcess.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isActive = false
                self?.process = nil
                self?.onStateChange?()
            }
        }
        
        do {
            try newProcess.run()
            self.process = newProcess
            self.isActive = true
            self.onStateChange?()
        } catch {
            self.isActive = false
            self.onStateChange?()
        }
    }

    func stop() {
        if process?.isRunning == true {
            process?.terminate()
        }
        process = nil
        isActive = false
        onStateChange?()
    }
    
    deinit {
        stop()
    }
}
