import Foundation

struct CountryUIModel {
    
    private let countryModel: CountryModel
    
    var name: String {
        return countryModel.name?.capitalized ?? "no-name"
    }
    
    var capital: String {
        return countryModel.capital?.capitalized ?? "no-capital"
    }
    
    var lat: Double {
        return countryModel.latlng?[0] ?? 0.0
    }
    
    var lang: Double {
        return countryModel.latlng?[1] ?? 0.0
    }
    
    init(countryModel: CountryModel) {
        self.countryModel = countryModel
    }
    
}
