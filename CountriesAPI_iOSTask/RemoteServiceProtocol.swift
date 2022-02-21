import Foundation
import RxSwift

protocol RemoteServiceProtocol: AnyObject {
    func getCountries() -> Observable<[CountryModel]>
}
