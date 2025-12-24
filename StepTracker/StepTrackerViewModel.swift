import SwiftUI

@MainActor
class StepTrackerViewModel: ObservableObject {
    
    @Published var steps: Int = 0
    @Published var isTracking: Bool = false
    @Published var errorMessage: String? = nil
    
    private let pedometerService: PedometerServiceProtocol
    
    init(service: PedometerServiceProtocol = PedometerService()) {
        self.pedometerService = service
    }
    
    func toggleTracking() {
        if isTracking {
            stopTracking()
        } else {
            startTracking()
        }
    }
    
    private func startTracking() {
        errorMessage = nil
        
        pedometerService.startCountingSteps { [weak self] result in
            Task { @MainActor in
                guard let self = self else { return }
                
                switch result {
                case .success(let stepsCount):
                    self.steps = stepsCount
                    self.isTracking = true
                    
                case .failure(let error):
                    self.isTracking = false
                    self.handleError(error)
                }
            }
        }
    }
    
    private func stopTracking() {
        pedometerService.stopCountingSteps()
        isTracking = false
    }
    
    private func handleError(_ error: PedometerError) {
        switch error {
        case .hardwareUnavailable:
            errorMessage = "This device does not support step tracking."
        case .unauthorized:
            errorMessage = "Permission Denied. Grant access to the app in Configurations."
        case .other(let err):
            errorMessage = "Error: \(err.localizedDescription)"
        }
    }
}
