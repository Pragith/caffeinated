import Foundation

final class CaffeinateManager {
    private(set) var isActive = false
    private var process: Process?
    private var timer: Timer?
    var onStateChange: (() -> Void)?

    func toggle() {
        isActive ? stop() : start()
    }

    func start(duration: TimeInterval? = nil) {
        stop() // Ensure clean start
        
        let newProcess = Process()
        newProcess.executableURL = URL(fileURLWithPath: "/usr/bin/caffeinate")
        newProcess.arguments = ["-d", "-i", "-m"]
        
        newProcess.terminationHandler = { [weak self] _ in
            DispatchQueue.main.async {
                self?.cleanup()
            }
        }
        
        do {
            try newProcess.run()
            self.process = newProcess
            self.isActive = true
            
            if let duration = duration {
                timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
                    self?.stop()
                }
            }
            
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
        cleanup()
    }
    
    private func cleanup() {
        process = nil
        timer?.invalidate()
        timer = nil
        isActive = false
        onStateChange?()
    }
    
    deinit {
        stop()
    }
}
