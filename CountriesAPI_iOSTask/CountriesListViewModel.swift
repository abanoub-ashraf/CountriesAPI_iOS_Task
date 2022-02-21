import Foundation
import RxSwift
import RxCocoa

class CountriesListViewModel {
    
    // MARK: - Properties
    
    let remoteService: RemoteService
    let localService: LocalService
    
    let countriesDataSource = BehaviorSubject<[CountryUIModel]>(value: [])
    
    let disposeBag = DisposeBag()
    
    weak var view: CountriesListViewControllerProtocol?
    
    var countrUIModel = PublishSubject<CountryUIModel>()
    
    // MARK: - Initializer
    
    init(remoteService: RemoteService, localService: LocalService) {
        self.remoteService  = remoteService
        self.localService   = localService
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
            } onError: { [weak self] _ in
                self?.view?.displayOfflineError(
                    errorMessage: "You're Offline. the Countries might be Outdated. please check your Internet Connection."
                )
                self?.fetchLocalCountries()
            }
            .disposed(by: disposeBag)
    }
    
    func fetchLocalCountries() {
        localService.getCountries()
            .map {
                $0.map {
                    CountryUIModel(
                        countryModel: CountryModel(
                            name: $0.countryName,
                            capital: $0.countryCapital,
                            latlng: [
                                $0.lat,
                                $0.lang
                            ]
                        )
                    )
                }
            }
            .subscribe { [weak self] countries in
//                var updatedCountries = Array(countries)
//                updatedCountries.insert((self?.countrUIModel)!, at: 0)
                self?.countriesDataSource.onNext(countries)
            } onError: { _ in }
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
    
    func saveLocalCountry(country: ControlEvent<CountryUIModel>.Element) {
        localService.saveCountry(
            name: country.name,
            capital: country.capital,
            lat: country.lat,
            lang: country.lang
        )
    }
    
    func deleteLocalCountry(country: ControlEvent<CountryUIModel>.Element) -> Bool {
        return localService.deleteCountry(name: country.name)
    }
    
}
