import Foundation
import RealmSwift

class CountryEntity: Object {
    @objc dynamic var countryName: String       = ""
    @objc dynamic var countryCapital: String    = ""
    @objc dynamic var lat: Double               = 0.0
    @objc dynamic var lang: Double              = 0.0
    
    ///
    /// set the primary key to prevent multiple adding
    /// and prevent crashing if trying to delete item that doesn't exist
    ///
    override class func primaryKey() -> String? {
        return "countryName"
    }
    
}
