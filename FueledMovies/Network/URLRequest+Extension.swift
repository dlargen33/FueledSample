//
//  URLRequest+Extension.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/6/25.
//

import Foundation

extension URLRequest {
    
    enum URLRequestError: Error {
        case invalidURL
        case failedToCreateURL
    }
   
    init(url: URL,
         cachePolicy: URLRequest.CachePolicy,
         timeoutInterval: TimeInterval,
         authorizationHeaderKey: String?,
         authorizationHeaderValue: String?,
         authorizationBearerToken: String?,
         headers:[String: String]?,
         requestType: RequestType,
         parameterType: ParameterType,
         responseType: ResponseType,
         parameters: Any?) throws {
        
        self = URLRequest(url: url,
                          cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy,
                          timeoutInterval: timeoutInterval )
    
        self.httpMethod = requestType.rawValue
    
        if let contentType = parameterType.contentType {
            self.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
    
        if let accept = responseType.accept {
            self.addValue(accept, forHTTPHeaderField: "Accept")
        }
        
        if let authKey =  authorizationHeaderKey {
            if let authValue = authorizationHeaderValue {
                self.setValue(authValue, forHTTPHeaderField: authKey)
            }
            else if let bearer = authorizationBearerToken {
                self.setValue("Bearer \(bearer)", forHTTPHeaderField: authKey)
            }
        }
        
        if let headerFields = headers {
            for (key, value) in headerFields {
                self.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        func parameterEncoding() throws {
            guard let parameters else { return }
            
            if let parametersDictionary = parameters as? [String: Any],
               !parametersDictionary.isEmpty {
                    switch requestType {
                    case .get, .delete:
                        let queryItems = parametersDictionary.urlQueryItems()
                        
                        guard var urlComponents = URLComponents(string: url.absoluteString) else {
                            throw URLRequestError.invalidURL
                        }
                        urlComponents.queryItems = queryItems
                        guard let finalURL = urlComponents.url else {
                            throw URLRequestError.failedToCreateURL
                        }
                        self.url = finalURL
                    case .post, .put, .patch:
                        let formatted = parametersDictionary.urlEncodedString()
                        self.httpBody = formatted.data(using: .utf8)
                    }
            }
            else {
                self.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            }
        }
        
        switch parameterType {
        case .none:
            break
        case .json:
            switch requestType {
            case .get, .delete:
                try parameterEncoding()
            case .patch, .put, .post:
                if let parameters {
                    self.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                }
            }
        case .formURLEncoded:
            try parameterEncoding()
        case .custom(_):
            self.httpBody = parameters as? Data
        }
    
    }
}
