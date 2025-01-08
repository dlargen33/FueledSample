//
//  FueledMoviesTests.swift
//  FueledMoviesTests
//
//  Created by Donald Largen on 1/7/25.
//

import XCTest
@testable import FueledMovies

final class FueledMoviesTests: XCTestCase {

    struct GetResult: Codable {
        let args: [String: String]
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGet () async throws {
        let sessionConfig = AsyncSession.SessionConfiguration(
            scheme: "http",
            host: "httpbin.org",
            authorizationHeaderKey: nil,
            authorizationHeaderValue: nil,
            headers: nil,
            isWrittingDisabled: false,
            timeout: 60)
        
        let asyncSession = AsyncSession(sessionConfiguration: sessionConfig)
        let params = ["foo": "bar"]
        
        let getResult: GetResult = try await asyncSession.get(
            path: "get",
            parameters: params,
            dateFormatters: [])
        
        guard getResult.args["foo"] == "bar" else {
            XCTFail()
            return
        }
    }

}
