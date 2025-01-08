//
//  RequestResponseTypes.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/6/25.
//

import Foundation

enum RequestType: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    
    /// Is the response for the given requst type cachable. Currently, only `get` responses
    /// can be cached.
    var isCachable: Bool {
        return self == .get
    }
    
    /// Does (or can) the request perform write transactions.
    var isWrite: Bool {
        switch self {
        case .get:
            return false
        case .post, .put, .patch, .delete:
            return true
        }
    }
}

enum ResponseType {
    case none
    case json
    case optionalJson
    case data
    case image
    case custom(String?)
    
    public var accept: String? {
        switch self {
        case .json, .optionalJson:
            return "application/json"
        case .custom(let value):
            return value
        default:
            return nil
        }
    }
}

enum ParameterType: CustomStringConvertible {
    case none
    case json
    case formURLEncoded
    case custom(String?)
    
    var contentType: String? {
        switch self {
        case .none:
            return nil
        case .json:
            return "application/json"
        case .formURLEncoded:
            return "application/x-www-form-urlencoded"
        case .custom(let value):
            return value
        }
    }
    
    var description: String {
        switch self {
        case .none:
            return "none"
        case .json:
            return "json"
        case .formURLEncoded:
            return "formURLEncoded"
        case .custom(let s):
            return "Custom: \(s ?? "")"
    
        }
    }
}
