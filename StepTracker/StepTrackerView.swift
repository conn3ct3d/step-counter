import SwiftUI

struct StepTrackerView: View {
    @StateObject private var viewModel = StepTrackerViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.1), .white], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Step Master")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                VStack(spacing: 10) {
                    Text("\(viewModel.steps)")
                        .font(.system(size: 80, weight: .heavy, design: .rounded))
                        .foregroundColor(.primary)
                        .contentTransition(.numericText())
                    
                    Text("Steps Today")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 5)
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    withAnimation {
                        viewModel.toggleTracking()
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.isTracking ? "pause.fill" : "play.fill")
                        Text(viewModel.isTracking ? "Stop" : "Start")
                    }
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.isTracking ? Color.orange : Color.green)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}
