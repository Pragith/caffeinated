import Foundation

final class CaffeinateManager {
    private(set) var isActive = false
    private var activity: NSObjectProtocol?
    private var timer: Timer?
    var onStateChange: (() -> Void)?

    func toggle() {
        isActive ? stop() : start()
    }

    func start(duration: TimeInterval? = nil) {
        stop() // Ensure clean start
        activity = ProcessInfo.processInfo.beginActivity(
            options: [.idleDisplaySleepDisabled, .idleSystemSleepDisabled],
            reason: "Caffeinate-d is keeping the Mac awake"
        )
        isActive = true

        if let duration {
            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
                self?.stop()
            }
        }

        onStateChange?()
    }

    func stop() {
        guard isActive || activity != nil else {
            timer?.invalidate()
            timer = nil
            return
        }

        if let activity {
            ProcessInfo.processInfo.endActivity(activity)
        }
        activity = nil
        timer?.invalidate()
        timer = nil
        isActive = false
        onStateChange?()
    }
}
