import Foundation
import RealmSwift
import RxSwift
import RxRealm

class LocalService {
    
    static let shared = LocalService()
    
    private var realm: Realm!
    
    private init() {
        initializeLocalDB()
        print(realm.configuration.fileURL)
    }
    
    func initializeLocalDB() {
        do {
            realm = try Realm()
            print("Realm Database is up and running...")
        } catch {
            print("Realm DB can't be initialized: \(error)")
        }
    }
    
}

extension LocalService: LocalServiceProtocol {
    
    func saveCountry(name: String, capital: String, lat: Double, lang: Double) {
        do {
            let countryEntity               = CountryEntity()
            countryEntity.countryName       = name
            countryEntity.countryCapital    = capital
            countryEntity.lat               = lat
            countryEntity.lang              = lang
            
            realm.beginWrite()
            realm.add(countryEntity, update: .all)
            
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func getCountries() -> Observable<Results<CountryEntity>> {
        let countries = realm.objects(CountryEntity.self)
        
        return Observable.collection(from: countries)
    }
    
    func deleteCountry(name: String) -> Bool {
        do {
            ///
            /// get the object that we wanna delete using its primary key
            /// if it exist, delete it and return true
            ///
            if let deletedObject  = realm.object(ofType: CountryEntity.self, forPrimaryKey: name) {
                try realm.write {
                    realm.delete(deletedObject)
                }
                return true
            }
        } catch {
            print(error)
        }
        
        ///
        /// if the object doesn't exist, return false
        ///
        return false
    }
    
}
