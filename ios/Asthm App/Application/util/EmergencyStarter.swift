import common
import PKHUD

class EmergencyStarter {
    
    func start() {
        LocationManager.shared.requestLocation { lat, lng in
            if let lat = lat, let lng = lng {
                store.dispatch(action: EmergencyRequests.StartEmergency(lat: KotlinDouble(double: lat), lng: KotlinDouble(double: lng)))
            } else {
                store.dispatch(action: EmergencyRequests.StartEmergency(lat: nil, lng: nil))
            }
        }
    }
}
