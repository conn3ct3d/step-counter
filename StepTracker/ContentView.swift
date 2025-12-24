import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StepTrackerViewModel()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.1), Color.white],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                
                VStack(spacing: 8) {
                    Text("Step Tracker")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    
                    Text("Daily Progress")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)
                
                Spacer()
                VStack(spacing: 0) {
                    Text("\(viewModel.steps)")
                        .font(.system(size: 80, weight: .heavy, design: .rounded))
                        .foregroundStyle(viewModel.isTracking ? .blue : .gray)

                        .contentTransition(.numericText())
                    
                    Text("Steps")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 250, height: 250)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 10)
                )
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Button(action: {
                    withAnimation(.spring()) {
                        viewModel.toggleTracking()
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.isTracking ? "pause.fill" : "play.fill")
                        Text(viewModel.isTracking ? "Stop" : "Start")
                    }
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isTracking ? Color.orange : Color.green)
                    .clipShape(Capsule())
                    .shadow(color: (viewModel.isTracking ? Color.orange : Color.green).opacity(0.4), radius: 10, x: 0, y: 5)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    ContentView()
}
