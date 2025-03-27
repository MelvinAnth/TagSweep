import SwiftUI

struct DragDropView: View {
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
                    Image(systemName: "arrow.down.doc")
                        .font(.system(size: 32))
                        .foregroundColor(isDropTargeted ? .accentColor : .gray)
                    
                    Text("Drag and drop files here")
                        .font(.headline)
                    
                    Text("or")
                        .foregroundColor(.secondary)
                    
                    Button("Select Files") {
                        selectFiles()
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
            
            if !appState.selectedFiles.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Files:")
                        .font(.headline)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(appState.selectedFiles, id: \.self) { url in
                                HStack {
                                    Text(url.lastPathComponent)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    Button {
                                        removeFile(url)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .frame(maxHeight: 150)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
    }
    
    private func selectFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        if panel.runModal() == .OK {
            appState.selectedFiles.append(contentsOf: panel.urls)
        }
    }
    
    private func handleDrop(_ providers: [NSItemProvider]) async {
        for provider in providers {
            if provider.canLoadObject(ofClass: URL.self) {
                if let url = try? await provider.loadObject(ofClass: URL.self) {
                    DispatchQueue.main.async {
                        if !appState.selectedFiles.contains(url) {
                            appState.selectedFiles.append(url)
                        }
                    }
                }
            }
        }
    }
    
    private func removeFile(_ url: URL) {
        appState.selectedFiles.removeAll { $0 == url }
    }
}

#Preview {
    DragDropView()
        .environmentObject(AppState())
}