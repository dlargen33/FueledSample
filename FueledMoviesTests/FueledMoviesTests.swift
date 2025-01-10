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
    
    func testGettingConfig() async throws {
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
        
        let asyncSession = AsyncSession(sessionConfiguration: sessionConfig)
        let _:Configuration = try await asyncSession.get(path: "/3/configuration",
                                                         parameters: nil,
                                                         dateFormatters: [])
    }
    
    func testGettingMostPopular() async throws {
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
        
        let asyncSession = AsyncSession(sessionConfiguration: sessionConfig)
        let response: MovieListResponse = try await asyncSession.get(path: MovieFilter.popular.route,
                                                                     parameters: nil,
                                                                     dateFormatters: [])
        
        XCTAssert(response.results.count > 0)
    }
    
    func testGettingTopRated() async throws {
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
        
        let asyncSession = AsyncSession(sessionConfiguration: sessionConfig)
        let response: MovieListResponse = try await asyncSession.get(path: MovieFilter.topRated.route,
                                                                     parameters: nil,
                                                                     dateFormatters: [])
        
        XCTAssert(response.results.count > 0)
    }
    
    func testDownloadImageData() async throws {
        let sessionConfig = AsyncSession.SessionConfiguration(scheme: "http",
                                                              host: "httpbin.org",
                                                              authorizationHeaderKey: nil,
                                                              authorizationHeaderValue: nil,
                                                              headers: nil,
                                                              isWrittingDisabled: false,
                                                              timeout: 60,
                                                              decodingStrategy: .convertFromSnakeCase,
                                                              apiKey: ["api_key": "e511ff224223cc84890762dcf623613c"])
        
        let asynSession = AsyncSession(sessionConfiguration: sessionConfig)
        var complete: Double? = nil
        let data = try await asynSession.download("/image/jpeg",
                                                  parameters: nil) {bytesWritten,
            totalBytesWritten,
            totalBytesExpectedToWrite,
            percentComplete in
            complete = percentComplete
        }
        
        guard let _ = complete else {
            XCTFail()
            return
        }
        
        guard let _ = UIImage(data: data) else {
            XCTFail()
            return
        }
    }
}
