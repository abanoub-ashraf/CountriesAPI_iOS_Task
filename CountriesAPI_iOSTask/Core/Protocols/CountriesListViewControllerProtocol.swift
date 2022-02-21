import UIKit

///
/// this protocl is for exposing its configureUIBinding() function so that
/// the view model can call it
///
protocol CountriesListViewControllerProtocol: AnyObject {
    func configureUIBinding()
    func configureTableViewCell(cell: UITableViewCell, model: CountryUIModel)
    func displayOfflineError(errorMessage: String)
}
