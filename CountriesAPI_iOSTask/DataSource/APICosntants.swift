import Foundation

struct APIConstants {
    ///
    /// the base string url that we are gonna use
    ///
    static let baseUrl = "https://restcountries.com/v2/"

    ///
    /// the parameters that we are gonna use
    ///
    struct Parameters {}
    
    ///
    /// the http header fields
    ///
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType    = "Content-Type"
        case acceptType     = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    ///
    /// the content type of the request
    ///
    enum ContentType: String {
        case json = "application/json"
    }
}
