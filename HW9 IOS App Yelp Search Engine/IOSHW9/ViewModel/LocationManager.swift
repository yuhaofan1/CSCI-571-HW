import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    // Variables
    private let locationManager = CLLocationManager()
    // Published Variables
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    typealias LocationResult = ((LocationStatus) -> ())
    fileprivate var oneTimeLocationResult: LocationResult? = nil
    // Initialization
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func updateLocation(complitionHandler: @escaping LocationResult){
        oneTimeLocationResult = complitionHandler
        self.locationManager.startUpdatingLocation()
    }
    // @todo: Look into this
    var statusString: String {
        
        // @todo: Look into this
        guard let status = locationStatus else {
            return "unknown"
        }
        
        // Switch statement on status
        switch status {
            case .notDetermined: return "notDetermined"
            case .authorizedWhenInUse: return "authorizedWhenInUse"
            case .authorizedAlways: return "authorizedAlways"
            case .restricted: return
            "restricted"
            case .denied: return "denied"
            default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            if let oneTime = oneTimeLocationResult {
                oneTime(.success(loc))
                oneTimeLocationResult = nil
                locationManager.stopUpdatingLocation()
            }
            debugPrint("Current Location \(loc.coordinate.longitude), \(loc.coordinate.latitude)")
        }
    }
}

enum LocationStatus{
    case success(CLLocation)
    case failer(Error?)
}
