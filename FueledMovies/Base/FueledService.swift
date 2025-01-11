//
//  FueledService.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/8/25.
//

import Foundation

/*
 Defines what a FueledService looks like.  Provides default implementation to create a configuration need
 for the Network Session.
 */
protocol FueledService {
    func createSessionConfiguration() -> AsyncSession.SessionConfiguration
}

extension FueledService {
    func createSessionConfiguration() -> AsyncSession.SessionConfiguration {
        let sessionConfig = AsyncSession.SessionConfiguration(
            scheme: "https",
            host: "api.themoviedb.org",
            authorizationHeaderKey: nil,
            authorizationHeaderValue: nil,
            headers: nil,
            isWrittingDisabled: false,
            timeout: 60,
            decodingStrategy: .convertFromSnakeCase,
            apiKey: ["api_key": "e511ff224223cc84890762dcf623613c"])
        return sessionConfig
    }
}
