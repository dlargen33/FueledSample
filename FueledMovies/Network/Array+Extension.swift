//
//  Array+Extension.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import Foundation

extension Array where Element: ExpressibleByStringLiteral {
    func urlEncodedString() -> String {
        self.compactMap { item in
            return (item as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        }
        .joined(separator: ",")
    }
}
