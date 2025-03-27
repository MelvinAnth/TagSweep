import SwiftUI

struct StepProgressView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(AppState.Step.allCases, id: \.self) { step in
                let isActive = appState.currentStep == step
                let isPast = step.rawValue < appState.currentStep.rawValue
                
                if step != .selectFiles {
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isPast ? .accentColor : .gray)
                        .frame(width: 40)
                }
                
                Button {
                    if isPast {
                        appState.currentStep = step
                    }
                } label: {
                    Circle()
                        .stroke(isPast || isActive ? .accentColor : .gray, lineWidth: 2)
                        .background(Circle().fill(isActive ? .accentColor : .clear))
                        .frame(width: 30, height: 30)
                        .overlay {
                            if isPast {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.accentColor)
                            } else if isActive {
                                Text("\(step.rawValue + 1)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            } else {
                                Text("\(step.rawValue + 1)")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray)
                            }
                        }
                }
                .buttonStyle(.plain)
                .disabled(!isPast)
            }
        }
        .overlay(alignment: .bottom) {
            HStack(spacing: 0) {
                ForEach(AppState.Step.allCases, id: \.self) { step in
                    if step != .selectFiles {
                        Rectangle()
                            .fill(.clear)
                            .frame(width: 40)
                    }
                    Text(step.title)
                        .font(.caption)
                        .foregroundColor(appState.currentStep == step ? .primary : .secondary)
                        .frame(width: 30)
                }
            }
            .offset(y: 25)
        }
    }
}

#Preview {
    StepProgressView()
        .environmentObject(AppState())
}