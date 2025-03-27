import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var bashRunner = BashRunner()
    
    var body: some View {
        VStack(spacing: 24) {
            StepProgressView()
                .padding(.top)
            
            switch appState.currentStep {
            case .selectFiles:
                DragDropView()
                
                Button("Next") {
                    appState.moveToNextStep()
                }
                .buttonStyle(.borderedProminent)
                .disabled(appState.selectedFiles.isEmpty)
                
            case .configureOptions:
                Text("Configure metadata options")
                    .font(.headline)
                
                HStack {
                    Button("Back") {
                        appState.moveToPreviousStep()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Preview") {
                        appState.moveToNextStep()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            case .preview:
                Text("Preview changes")
                    .font(.headline)
                
                HStack {
                    Button("Back") {
                        appState.moveToPreviousStep()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Process") {
                        appState.moveToNextStep()
                        Task {
                            appState.isProcessing = true
                            for url in appState.selectedFiles {
                                _ = try? await bashRunner.run("/usr/local/bin/exiftool", arguments: ["-all=", url.path])
                            }
                            appState.isProcessing = false
                            appState.moveToNextStep()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
            case .processing:
                VStack {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Processing files...")
                        .font(.headline)
                        .padding(.top)
                }
                
            case .complete:
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                    
                    Text("Processing Complete!")
                        .font(.headline)
                    
                    Button("Start Over") {
                        appState.selectedFiles.removeAll()
                        appState.currentStep = .selectFiles
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .frame(minWidth: 600, minHeight: 400)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}