import Foundation
import RxSwift
import RxCocoa

class CountriesListViewModel {
    
    // MARK: - Properties

    let remoteService: RemoteService
    
    weak var view: CountriesListViewControllerProtocol?
    
    let countriesDataSource = BehaviorSubject<[CountryUIModel]>(value: [])
    
    let disposeBag = DisposeBag()
    
    // MARK: - Initializer
    
    init(remoteService: RemoteService) {
        self.remoteService  = remoteService
    }
    
    // MARK: - Helper Functions

    func fetchCountryViewModels() {
        remoteService.getCountries()
        ///
        /// we wanna convert the array of type CountryModel that the api call returns
        /// into an array of type CoutrnyUIModel so we can use it here
        ///
            .map {
                $0.map {
                    CountryUIModel(countryModel: $0)
                }
            }
            .subscribe { [weak self] countries in
                self?.countriesDataSource.onNext(countries)
            } onError: { [weak self] error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - CountriesListViewModelProtocol

extension CountriesListViewModel: CountriesListViewModelProtocol {
    ///
    /// this function is exposed to the view controller
    /// to be called from there through the protocol
    ///
    /// it will be called from inside the viewDidLoad() of the view controller
    ///
    /// it will trigger the api call from inside this viewmodel
    /// to fill the countriesDatasource with data then it will call
    /// the configureUIBinding() of the view controller through its own protocol
    ///
    func viewModelDidLoad() {
        fetchCountryViewModels()
        view?.configureUIBinding()
    }
    
}
