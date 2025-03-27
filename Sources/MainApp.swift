import SwiftUI

@main
struct TagSweepApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

class AppState: ObservableObject {
    enum Step: Int, CaseIterable {
        case selectFiles
        case configureOptions
        case preview
        case processing
        case complete
        
        var title: String {
            switch self {
            case .selectFiles: return "Select Files"
            case .configureOptions: return "Configure Options"
            case .preview: return "Preview Changes"
            case .processing: return "Processing"
            case .complete: return "Complete"
            }
        }
    }
    
    @Published var currentStep: Step = .selectFiles
    @Published var selectedFiles: [URL] = []
    @Published var isProcessing = false
    @Published var processOutput: String = ""
    
    func moveToNextStep() {
        guard let currentIndex = Step.allCases.firstIndex(of: currentStep),
              currentIndex + 1 < Step.allCases.count else { return }
        currentStep = Step.allCases[currentIndex + 1]
    }
    
    func moveToPreviousStep() {
        guard let currentIndex = Step.allCases.firstIndex(of: currentStep),
              currentIndex > 0 else { return }
        currentStep = Step.allCases[currentIndex - 1]
    }
}