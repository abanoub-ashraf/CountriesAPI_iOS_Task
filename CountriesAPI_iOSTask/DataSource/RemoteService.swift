import Alamofire
import RxSwift

class RemoteService: RemoteServiceProtocol {
    
    // MARK: - Properties

    static let shared = RemoteService()

    // MARK: - Initializer

    private init() {}

    // MARK: - Web Requests

    ///
    /// this function will be called from the view controller
    ///
    func getCountries() -> Observable<[CountryModel]> {
        return request(
            ApiRouter.getCountries
        )
    }
}

extension RemoteService {
    ///
    /// this method will make the http request, it takes the endpoint it needs
    /// - Params: urlConvertible endpoint
    /// - Returns: observable
    ///
    private func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        ///
        /// Creates an RxSwift observable, which will be the one to call the request when subscribed to
        ///
        return Observable<T>.create { observer in
            ///
            /// AF.request() Trigger the HttpRequest using AlamoFire (AF)
            ///
            /// responseDecodable() Adds a handler using a DecodableResponseSerializer to be called once
            /// the request has finished
            ///
            /// (of: ) takes a Decodable type to decode from response data.
            ///
            let request = AF.request(urlConvertible).responseDecodable(of: T.self) { response in
                switch response.result {
                        ///
                        /// on success, we wanna send the observed data to the caller site
                        ///
                    case .success(let value):
                        ///
                        /// Everything is fine, return the value in onNext
                        ///
                        observer.onNext(value)
                        observer.onCompleted()
                        
                        ///
                        /// on error, we wanna send the error that happend to the caller site
                        ///
                    case .failure(let error):
                        switch response.response?.statusCode {
                            case 403:
                                observer.onError(ApiError.forbidden)
                            case 404:
                                observer.onError(ApiError.notFound)
                            case 409:
                                observer.onError(ApiError.conflict)
                            case 500:
                                observer.onError(ApiError.internalServerError)
                            default:
                                observer.onError(error)
                        }
                }
            }
            
            ///
            /// Finally, we return a disposable to stop the request when needed
            ///
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
