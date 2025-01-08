//
//  NSDictionary+Extension.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral {
    
    func urlQueryItems() -> [URLQueryItem] {
        let items = reduce([]) { current, keyValuePair ->[URLQueryItem] in
            current + [URLQueryItem(name:"\(keyValuePair.key)", value: "\(keyValuePair.value)")]
        }
        return items
    }
    
    func urlEncodedString() -> String {
        let items = reduce([]) { current, keyValuePair ->[String] in
            if let encodedValue = "\(keyValuePair.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return current + ["\(keyValuePair.key)=\(encodedValue)"]
            }
            return current
        }
        return items.joined(separator: "&")
    }
}
