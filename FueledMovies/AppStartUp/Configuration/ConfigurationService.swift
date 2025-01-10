//
//  ConfigurationService.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/8/25.
//

import Foundation

class ConfigurationService: FueledService {
    
    @discardableResult
    func getConfig() async throws -> Configuration {
        let asyncSession = AsyncSession(sessionConfiguration: createSessionConfiguration())
        let config:Configuration = try await asyncSession.get(path: "/3/configuration",
                                                              parameters: nil,
                                                              dateFormatters: [])
        ConfigurationRepository.shared.add(configuration: config)
        return config
    }
}
