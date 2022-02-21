import Foundation
import RealmSwift
import Realm
import RxSwift

protocol LocalServiceProtocol: AnyObject {
    func getCountries() -> Observable<Results<CountryEntity>>
    func saveCountry(name: String, capital: String, lat: Double, lang: Double)
    func deleteCountry(name: String) -> Bool
}
