import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            if let icon = NSApp.applicationIconImage {
                Image(nsImage: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .accessibilityLabel("Caffeinate-d app icon")
            } else {
                Image(systemName: "cup.and.saucer")
                    .font(.system(size: 60))
                    .accessibilityLabel("Caffeinate-d app icon")
            }
            
            VStack(spacing: 5) {
                Text("Caffeinate-d")
                    .font(.headline)
                Text("Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 5) {
                Text("Developed by Pragith Prakash")
            }
            
            Text("© 2026 Pragith AI Inc.")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(width: 300)
    }
}
