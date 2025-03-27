import SwiftUI

struct FolderDropView: View {
    @EnvironmentObject var appState: AppState
    @State private var isDropTargeted = false
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10]))
                    .foregroundColor(isDropTargeted ? .accentColor : .gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(Color.secondary.opacity(0.1))
                
                VStack(spacing: 12) {
                    Image(systemName: "arrow.down.folder")
                        .font(.system(size: 32))
                        .foregroundColor(isDropTargeted ? .accentColor : .gray)
                    
                    Text("Drag and drop folder here")
                        .font(.headline)
                    
                    Text("or")
                        .foregroundColor(.secondary)
                    
                    Button("Select Folder") {
                        selectFolder()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onDrop(of: [.fileURL], isTargeted: $isDropTargeted) { providers in
                Task {
                    await handleDrop(providers)
                }
                return true
            }
            
            if let selectedFolder = appState.selectedFolder {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Folder:")
                        .font(.headline)
                    
                    HStack {
                        Text(selectedFolder.lastPathComponent)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Button {
                            appState.selectedFolder = nil
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.vertical, 4)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func selectFolder() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        
        if panel.runModal() == .OK {
            if let url = panel.urls.first {
                appState.selectedFolder = url
                validateFolder(url)
            }
        }
    }
    
    private func handleDrop(_ providers: [NSItemProvider]) async {
        for provider in providers {
            if provider.canLoadObject(ofClass: URL.self) {
                if let url = try? await provider.loadObject(ofClass: URL.self) {
                    var isDir: ObjCBool = false
                    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
                        DispatchQueue.main.async {
                            appState.selectedFolder = url
                            validateFolder(url)
                        }
                        break
                    }
                }
            }
        }
    }
    
    private func validateFolder(_ url: URL) {
        Task {
            let script = "echo \"Validating folder: (url.path)\"; if [ ! -d \"(url.path)\" ]; then echo \"ERROR: Not a valid directory\"; else echo \"✓ Ready to process: $(ls -1 \"(url.path)\" | wc -l) files\"; fi"
            try? await BashRunner().runScript(script)
        }
    }
}

#Preview {
    FolderDropView()
        .environmentObject(AppState())
}