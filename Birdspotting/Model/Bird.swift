import Foundation
import FirebaseFirestore
import CoreLocation

struct Bird: Identifiable, Codable {
    @DocumentID var id: String?
    let species: SPECIES
    let date: Timestamp
    let location: Location
    let note: String?
    let image: Data?
    
    enum SPECIES: String, Codable, CaseIterable {
        case BaldEagle = "Bald Eagle"
        case BohemianWaxwing = "Bohemian Waxwing"
        case Eagle, Liverbird, Mallard, Raven, Swans
    }
    
    
    struct Location: Codable {
        var latitude: Double
        var longitude: Double
        
        init(coordinate: CLLocationCoordinate2D) {
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
        }
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}
