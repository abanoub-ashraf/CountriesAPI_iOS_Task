import UIKit
import RxSwift
import RxCocoa

class CountriesListViewController: UIViewController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    
    private var viewModel: CountriesListViewModelProtocol = CountriesListViewModel(
        remoteService: RemoteService.shared
    )
    
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
