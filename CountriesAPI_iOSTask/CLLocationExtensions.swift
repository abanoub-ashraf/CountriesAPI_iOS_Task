import MapKit

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?) -> ()) {
        ///
        /// Submits a reverse-geocoding request for the specified location
        ///
        CLGeocoder().reverseGeocodeLocation(self) { mark, error in
            completion(
                mark?.first?.name,
                mark?.first?.country
            )
        }
    }
}
