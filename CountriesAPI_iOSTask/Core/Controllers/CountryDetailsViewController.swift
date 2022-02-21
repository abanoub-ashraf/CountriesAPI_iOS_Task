import UIKit
import RxSwift
import RxCocoa

class CountryDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    var name: String    = ""
    var capital: String = ""
    var lat: Double     = 0.0
    var lang: Double    = 0.0
    
    var countryModel: ControlEvent<CountryUIModel>.Element? {
        didSet {
            self.name       = countryModel?.name ?? "no-name"
            self.capital    = countryModel?.capital ?? "no-capital"
            self.lat        = countryModel?.lat ?? 0.0
            self.lang       = countryModel?.lang ?? 0.0
        }
    }
    
    // MARK: - Initializer
    
    convenience init() {
        self.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - UI
    
    @IBOutlet private weak var countryNameLabel: UILabel!
    @IBOutlet private weak var countryCapitalLabel: UILabel!
    @IBOutlet private weak var latLabel: UILabel!
    @IBOutlet private weak var langLabel: UILabel!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    private func configureUI() {
        self.countryNameLabel.text              = "Country Name:\n \(self.name)"
        self.countryNameLabel.textAlignment     = .center
        self.countryCapitalLabel.text           = "Country Capital:\n \(self.capital)"
        self.countryCapitalLabel.textAlignment  = .center
        self.latLabel.text                      = "Latitude:\n \(self.lat)"
        self.latLabel.textAlignment             = .center
        self.langLabel.text                     = "Langitude:\n \(self.lang)"
        self.langLabel.textAlignment            = .center
    }
    
}
