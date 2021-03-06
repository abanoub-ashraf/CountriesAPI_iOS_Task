import Foundation
import RxSwift
import RxCocoa

protocol CountriesListViewModelProtocol: AnyObject {
    
    // MARK: - Properties
    
    ///
    /// a property of the view controller protocol to be able to communicate
    /// with the view controller
    ///
    var view: CountriesListViewControllerProtocol? { get set }
    
    ///
    /// this represents a value that changes over time
    ///
    var countriesDataSource: BehaviorSubject<[CountryUIModel]> { get }
    
    var currentLocationCountryUIModel: PublishSubject<CountryUIModel> { get }
    
    // MARK: - Methods
    
    func viewModelDidLoad()
    
    func saveLocalCountry(country: ControlEvent<CountryUIModel>.Element)
    
    func deleteLocalCountry(country: ControlEvent<CountryUIModel>.Element) -> Bool
    
}
