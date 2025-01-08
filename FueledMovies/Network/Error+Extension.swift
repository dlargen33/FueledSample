//
//  Error+Extension.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/7/25.
//

import Foundation

extension NSError {
    static var errorDomain = "com.largensoftware.error"
    
    static func tentaclesError(code: Int, localizedDescription: String) -> Error {
        let error = NSError(domain: NSError.errorDomain,
                            code: code,
                            userInfo: [NSLocalizedDescriptionKey: localizedDescription])
        return error
    }
}
