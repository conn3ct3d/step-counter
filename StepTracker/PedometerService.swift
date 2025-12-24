import CoreMotion
import Foundation

enum PedometerError: Error {
    case hardwareUnavailable
    case unauthorized
    case other(Error)
}

protocol PedometerServiceProtocol {
    var isStepCountingAvailable: Bool { get }
    func startCountingSteps(completion: @escaping (Result<Int, PedometerError>) -> Void)
    func stopCountingSteps()
}

class PedometerService: PedometerServiceProtocol {
    private let pedometer = CMPedometer()
    
    var isStepCountingAvailable: Bool {
        return CMPedometer.isStepCountingAvailable()
    }
    
    func startCountingSteps(completion: @escaping (Result<Int, PedometerError>) -> Void) {
        guard isStepCountingAvailable else {
            completion(.failure(.hardwareUnavailable))
            return
        }
        

        pedometer.startUpdates(from: Date()) { data, error in
            
            if let error = error {
                let nsError = error as NSError
                

                if nsError.domain == CMErrorDomain && nsError.code == 105 {
                    completion(.failure(.unauthorized))
                } else {
                    completion(.failure(.other(error)))
                }
                return
            }
            
            if let data = data {
                completion(.success(data.numberOfSteps.intValue))
            }
        }
    }
    
    func stopCountingSteps() {
        pedometer.stopUpdates()
    }
}
