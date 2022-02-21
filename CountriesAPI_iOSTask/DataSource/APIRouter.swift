import Foundation
import Alamofire

///
/// the api endpoints of the application
///
/// types adopting the URLRequestConvertible protocol can be used
/// to safely construct URLRequests
///
enum ApiRouter: URLRequestConvertible {
    ///
    /// the endpoint we gonna call later
    ///
    case getCountries
    
    ///
    /// set the method for each endpoint we have
    ///
    private var method: HTTPMethod {
        switch self {
            case .getCountries:
                return .get
        }
    }
    
    ///
    /// set the path for each endpoint we have
    ///
    private var path: String {
        switch self {
            case .getCountries:
                return "all"
        }
    }
    
    ///
    /// set the parameters for each endpoint we have
    ///
    private var parameters: Parameters? {
        switch self {
            case .getCountries:
                return [:]
        }
    }
    
    ///
    /// make the url request that we gonna use for making the http request
    ///
    func asURLRequest() throws -> URLRequest {
        ///
        /// the base string url that the url request needs
        ///
        let url = try APIConstants.baseUrl.asURL()

        ///
        /// the url request we're making inside this function
        /// using the string url and the path we want add to it
        ///
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))

        ///
        /// set the method that the request will use
        ///
        urlRequest.httpMethod = method.rawValue

        ///
        /// set the header value that the request needs
        ///
        urlRequest.setValue(
            APIConstants.ContentType.json.rawValue,
            forHTTPHeaderField: APIConstants.HttpHeaderField.acceptType.rawValue
        )

        urlRequest.setValue(
            APIConstants.ContentType.json.rawValue,
            forHTTPHeaderField: APIConstants.HttpHeaderField.contentType.rawValue
        )

        ///
        /// a type used to define how a set of parameters are applied to a URLRequest
        ///
        let encoding: ParameterEncoding = {
            switch method {
                case .get:
                    return URLEncoding.default
                default:
                    return JSONEncoding.default
            }
        }()

        ///
        /// creates a URLRequest by encoding parameters and applying them on the passed request
        ///
        return try encoding.encode(urlRequest, with: parameters)
    }
}
