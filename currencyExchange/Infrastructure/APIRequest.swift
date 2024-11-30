//
//  DataService.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//


import Foundation





enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}
enum APIResult<Body> {
    case success(APIResponse<Body>)
    case failure(APIError)
}
enum ResponseData<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
enum APIError: Error {
    case errorFromApi(Error)
    case invalidResponse
}

struct HTTPHeader {
    let field: String
    let value: String
}

class APIRequest {
    let method: HTTPMethod
    let path: String
    var queryItems: [String: Any]?
    var bodyParamatersEncodable: Encodable? = nil
    var bodyParam: [String: String]?
    var body: Data?
    var isFullPath: Bool
    
    init(method: HTTPMethod, path: String, paramDict: [String: String]? = nil, param: Encodable? = nil, fullPath: Bool = false, queryItems: [String: Any]? = nil) {
        self.method = method
        self.path = path
        self.isFullPath = fullPath
        self.bodyParamatersEncodable = param
        self.bodyParam = paramDict
        self.queryItems = queryItems
    }
}

struct APIResponse<Body> {
    let statusCode: Int
    let body: Body
}

class APIClient {
    
    private let baseURL = URL(string: APIConstants.baseUrl)!
    
    func perform<T:Decodable>(_ request: APIRequest,_ decoder: T.Type,_ completion: @escaping (ResponseData<T, APIError>) -> Void) {
                

        let urlComponents = setUrlCompo(request)
        var urlRequest: URLRequest!
        setParamInRequest(request, urlComponents) { urlReq, error in
            if error == nil {
                urlRequest = urlReq!
            } else {
                completion(.failure(error!))
            }
        }
        let url = request.path
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        let sSLPinning = SSLPinning()
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
  
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            self.errorHandler((data, response, error)) { apiError in
                    guard let _ = apiError else {
                    do {
                        let apiResponse = try JSONDecoder().decode(T.self, from: data!)
                        print("API_Response:",apiResponse)
                        completion(.success(apiResponse))
                    } catch let parseErr {
                        print("PARSE___     ", parseErr)
                        let error = NSError(domain: "", code: 90005, userInfo: [NSLocalizedDescriptionKey : "Parse error"])
                        let apiError = APIError.errorFromApi(error)
                        print("full url for api ",urlRequest.url ?? "")
                        completion(.failure(apiError))
                    }
                    return
                }
                completion(.failure(apiError!))
            }
        }
        task.resume()
    }
    
    private func setUrlCompo(_ request: APIRequest) -> URLComponents {
        var urlComponents: URLComponents
        
        if request.isFullPath {
            guard let fullPathURL = URL(string: request.path) else {
                fatalError("Invalid full path URL")
            }
            urlComponents = URLComponents(url: fullPathURL, resolvingAgainstBaseURL: false)!
        } else {
            urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
            urlComponents.path = baseURL.path + request.path
        }
        
        if let queryItems = request.queryItems {
            urlComponents.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        return urlComponents
    }
    
    private func setParamInRequest(_ request: APIRequest, _ urlComponents: URLComponents, completion: @escaping (URLRequest?, APIError?) -> Void) {
        guard let finalURL = urlComponents.url else {
            let error = NSError(domain: "", code: 90002, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, APIError.errorFromApi(error))
            return
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = request.method.rawValue
        
        if let bodyParams = request.bodyParam {
            do {
                let bodyData = try JSONSerialization.data(withJSONObject: bodyParams, options: [])
                urlRequest.httpBody = bodyData
            } catch {
                let error = NSError(domain: "", code: 90010, userInfo: [NSLocalizedDescriptionKey: "Failed to encode body parameters"])
                completion(nil, APIError.errorFromApi(error))
                return
            }
        } else if let bodyEncodable = request.bodyParamatersEncodable {
            guard let bodyData = bodyEncodable.toData() else {
                let error = NSError(domain: "", code: 90003, userInfo: [NSLocalizedDescriptionKey: "Failed to encode encodable body"])
                completion(nil, APIError.errorFromApi(error))
                return
            }
            urlRequest.httpBody = bodyData
        }
        
        completion(urlRequest, nil)
    }

    private func errorHandler(_ ServerRespone: (Data?, URLResponse?, Error?), completion: @escaping (APIError?) -> Void) {
        if ServerRespone.2 != nil {
            let error = ServerRespone.2 as? URLError
            let errorNS = NSError(domain: "", code: error!.code.rawValue, userInfo: [NSLocalizedDescriptionKey : error!.localizedDescription])
            let apiError = APIError.errorFromApi(errorNS)
            completion(apiError)
            return
        }
        if let response = ServerRespone.1 as? HTTPURLResponse {
            if response.statusCode != 200 {
                switch response.statusCode {
                case 401...403:
                    
                    let errorNS = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : "Un Authorized"])
                    let apiError = APIError.errorFromApi(errorNS)
                    completion(apiError)
                    return
                case 404:
                    let errorNS = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : "Server Not found"])
                    let apiError = APIError.errorFromApi(errorNS)
                    completion(apiError)
                    return
                case 429:
                    print("Too many request:","\(response.statusCode)")
                    return
                default:
                    break
                }

            } else {
                guard let _ = ServerRespone.0 else {
                    let errorNS = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey : "Invalid Data"])
                    completion(APIError.errorFromApi(errorNS))
                    return
                }
            }
        } else {
            let errorNS = NSError(domain: "", code: 90004, userInfo: [NSLocalizedDescriptionKey : "Invalid Response"])
            completion(APIError.errorFromApi(errorNS))
            return
        }
        completion(nil)
    }
    
    
}

private extension Encodable {
    func toData() -> Data? {
        do {
            let data = try JSONEncoder().encode(self)
            return data
        } catch {
            return nil
        }
    }
}

