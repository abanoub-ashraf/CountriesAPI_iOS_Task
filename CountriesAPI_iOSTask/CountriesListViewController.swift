import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import CoreLocation

class CountriesListViewController: UIViewController {
    
    // MARK: - Properties
    
    private var locationManager: CLLocationManager?
    
    let disposeBag = DisposeBag()
    
    private var viewModel: CountriesListViewModelProtocol = CountriesListViewModel(
        remoteService: RemoteService.shared,
        localService: LocalService.shared
    )
    
    var city: String = ""
    var country: String = ""
    var lat: Double = 0.0
    var lang: Double = 0.0
    
    // MARK: - UI
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///
        /// set this class to be the delegate for the viewmodel protocol
        ///
        viewModel.view = self
        
        ///
        /// use the function of that delegate
        ///
        viewModel.viewModelDidLoad()
        
        configureCoreLocation()
    }
    
    // MARK: - Helper Functions
    
    private func configureCoreLocation() {
        locationManager = CLLocationManager()
        
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
    }
    
    private func pushDetailsViewControllerOnTheScreen(countryModel: ControlEvent<CountryUIModel>.Element) {
        let storyboard      = UIStoryboard(name: "Main", bundle: nil)
        let controllerID    = String(describing: CountryDetailsViewController.self)
        
        let detailsViewController = storyboard.instantiateViewController(
            withIdentifier: controllerID
        ) as! CountryDetailsViewController
        
        detailsViewController.countryModel = countryModel
        
        self.present(detailsViewController, animated: true)
    }
    
    // MARK: - TableView Methods
    
    ///
    /// bind the data we got from the view model to the table view
    ///
    func bindTableViewDatasource() {
        viewModel
            .countriesDataSource
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { _, uiModel, cell in
                self.configureTableViewCell(cell: cell, model: uiModel)
            }
            .disposed(by: disposeBag)
    }
    
    ///
    /// specify what to happen when a cell in the table view is selected
    ///
    func bindDidSelectModel() {
        tableView.rx
            .modelSelected(CountryUIModel.self)
            .observe(on: MainScheduler.instance)
            .bind { country in
                ///
                /// display the details of the country in a new screen
                ///
                self.pushDetailsViewControllerOnTheScreen(countryModel: country)
                self.viewModel.saveLocalCountry(country: country)
            }
            .disposed(by: disposeBag)
        
        deleteFromTableView()
    }
    
    func deleteFromTableView() {
        tableView
            .rx
            .modelDeleted(CountryUIModel.self)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] country in
                ///
                /// if this function returns true, the wen are deleting an item from the database
                ///
                if self?.viewModel.deleteLocalCountry(country: country) ?? false {
                    do {
                        ///
                        /// grab the values of the datasource array from the viewmolde
                        ///
                        let dataSource = try self?.viewModel.countriesDataSource.value()
                        
                        ///
                        /// remove from it the passed model object to update ui
                        ///
                        let updatedDataSource = dataSource?.filter { model in
                            country.name != model.name
                        }
                        
                        ///
                        /// pass the new updated array back to the datasource of the viewmodel
                        ///
                        self?.viewModel
                            .countriesDataSource
                            .onNext(updatedDataSource ?? [])
                    } catch {
                        print(error)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - CountriesListViewControllerProtocol

extension CountriesListViewController: CountriesListViewControllerProtocol {
    ///
    /// configure binding the table view with data and
    /// the did select row action for each cell
    ///
    func configureUIBinding() {
        bindTableViewDatasource()
        bindDidSelectModel()
    }
    
    ///
    /// configure the table view cell with model data
    ///
    func configureTableViewCell(cell: UITableViewCell, model: CountryUIModel) {
        cell.backgroundColor                = .systemGray
        
        cell.textLabel?.text                = "Country's Name: \(model.name)"
        cell.textLabel?.font                = .systemFont(ofSize: 20)
        cell.textLabel?.textAlignment       = .center
        
        cell.detailTextLabel?.text          = "Country's Capital: \(model.capital)"
        cell.detailTextLabel?.textAlignment = .center
        cell.detailTextLabel?.font          = .systemFont(ofSize: 20)
    }
    
    func displayOfflineError(errorMessage: String) {
        DispatchQueue.main.async {
            self.showToast(text: errorMessage)
        }
    }
    
}

// MARK: - CLLocationManagerDelegate

extension CountriesListViewController: CLLocationManagerDelegate {
    
    ///
    /// tells the delegate that the new location data is available
    ///
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        ///
        /// the last location is the most accurate one so that's what we want
        ///
        if let location = locations.last {
            ///
            /// comment this line if you wanna the location to be kept updating
            /// when the app goes to the background
            ///
            locationManager?.stopUpdatingLocation()
            
            let lat  = location.coordinate.latitude
            let lang = location.coordinate.longitude
            
            let location = CLLocation(latitude: lat, longitude: lang)
            
            location.fetchCityAndCountry { city, country in
                guard
                    let city = city,
                    let country = country
                else { return }
                
                self.city = city
                self.country = country
                self.lat = lat
                self.lang = lang
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
