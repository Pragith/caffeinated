import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            if let icon = NSApp.applicationIconImage {
                Image(nsImage: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
            } else {
                Text("☕")
                    .font(.system(size: 60))
            }
            
            VStack(spacing: 5) {
                Text("Caffeinate-d")
                    .font(.headline)
                Text("Version 0.1.2")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 5) {
                Text("Developed by Pragith Prakash")
                Link("pragith.net", destination: URL(string: "https://pragith.net/apps/caffeinated")!)
                    .font(.caption)
            }
            
            Text("© 2026 Pragith AI Inc.")
                .font(.caption2)
                .foregroundColor(.secondary)
            
            Button(action: {
                if let url = URL(string: "https://buymeacoffee.com/pragith") {
                    NSWorkspace.shared.open(url)
                }
            }) {
                Image("BMCButton")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
            }
            .buttonStyle(.plain)
            .padding(.top, 10)
        }
        .padding()
        .frame(width: 300)
    }
}
