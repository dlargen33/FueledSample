//
//  AsyncSession.swift
//  FueledMovies
//
//  Created by Donald Largen on 1/6/25.
//

import Foundation

typealias EndpointProgress = (_ bytesWritten: Int64,
                              _ totalBytesWritten: Int64,
                              _ totalBytesExpectedToWrite: Int64,
                              _ percentComplete: Double?) -> Void

class AsyncSession: NSObject {
    
    enum QueryParameterPlusEncodingBehavior {
        case `default`
        case encode
    }
    
    enum SessionError: Error {
        case invalidResponseType
        case unknownHTTPStatusCode
        case unauthorized
    }
    
    struct SessionConfiguration {
        var scheme: String
        var host: String
        var authorizationHeaderKey: String?
        var authorizationHeaderValue: String?
        var authorizationBearerToken: String?
        var headers: [String: String]?
        var isWrittingDisabled: Bool?
        var timeout: Double?
        var queryParameterPlusEncodingBehavior: QueryParameterPlusEncodingBehavior
        var allowsLongRunningTasks: Bool
        
        init(scheme: String,
             host: String,
             authorizationHeaderKey: String?,
             authorizationHeaderValue: String?,
             headers: [String: String]?,
             isWrittingDisabled: Bool?,
             timeout: Double?,
             queryParameterPlusEncodingBehavior: QueryParameterPlusEncodingBehavior = .default,
             allowsLongRunningTasks: Bool = false) {
            self.scheme = scheme
            self.host = host
            self.authorizationHeaderKey = authorizationHeaderKey
            self.authorizationHeaderValue = authorizationHeaderValue
            self.headers = headers
            self.isWrittingDisabled = isWrittingDisabled
            self.timeout = timeout
            self.queryParameterPlusEncodingBehavior = queryParameterPlusEncodingBehavior
            self.allowsLongRunningTasks = allowsLongRunningTasks
        }
    }
    
    private let sessionConfiguration: AsyncSession.SessionConfiguration
    private lazy var urlSession: URLSession = {
        return URLSession(configuration: urlSessionConfiguration,
                          delegate: self,
                          delegateQueue: nil)
    }()
    
    
    var progressHandler: EndpointProgress?
    var unauthorizedStatusCodes: [HTTPStatusCode] = [.unauthorized, .forbidden]
    var urlSessionConfiguration: URLSessionConfiguration
    
    var host: String? {
        return sessionConfiguration.host
    }
    
    var scheme: String {
        return sessionConfiguration.scheme
    }
    
    init (sessionConfiguration: AsyncSession.SessionConfiguration ) {
        self.sessionConfiguration = sessionConfiguration
        self.urlSessionConfiguration = URLSessionConfiguration.default
        super.init()
    }
    
    func get<Output: Codable>(path: String,
                              parameterType: ParameterType = .json,
                              parameters: [String: Any]?,
                              dateFormatters: [DateFormatter]) async throws -> Output {
        
        let request = try self.setupRequest(path: path,
                                            requestType: .get,
                                            responseType: .json,
                                            parameterType: parameterType,
                                            parameters: parameters)
        
        let (data, urlResponse)  = try await self.urlSession.data(for: request, delegate: self)
        
        try validateResponse(urlResponse: urlResponse)
        let result: Output = try self.handleResponse(data: data,
                                                     urlResponse: urlResponse,
                                                     dateFormatters: dateFormatters)
        return result
    }
}

extension AsyncSession {
    
    private func composedURL(_ path: String) -> URL? {
        // path may be a fully qualified URL string - check for that
        if let precomposed = URL(string: path) {
            if precomposed.scheme != nil && precomposed.host != nil {
                return precomposed
            }
        }
        
        let urlString = sessionConfiguration.scheme + "://" + sessionConfiguration.host
        guard let url = URL(string: urlString) else {return nil}
        return url.appendingPathComponent(path)
    }
    
    private func setupRequest(path: String,
                              requestType: RequestType,
                              responseType: ResponseType,
                              parameterType: ParameterType,
                              parameters: Any?) throws -> URLRequest {
        
        
        guard let url = composedURL(path) else {
            throw URLError(
                .badURL,
                userInfo: [NSURLErrorFailingURLStringErrorKey: path])
        }
        

        let request = try URLRequest(url: url,
                                     cachePolicy: URLRequest.CachePolicy.useProtocolCachePolicy,
                                     timeoutInterval: sessionConfiguration.timeout ?? 60.0,
                                     authorizationHeaderKey: sessionConfiguration.authorizationHeaderKey,
                                     authorizationHeaderValue: sessionConfiguration.authorizationHeaderValue,
                                     authorizationBearerToken: sessionConfiguration.authorizationBearerToken,
                                     headers: sessionConfiguration.headers,
                                     requestType: requestType,
                                     parameterType: parameterType,
                                     responseType: ResponseType.data,
                                     parameters: parameters)
        
       return request
    }
    
    @discardableResult
    private func validateResponse(urlResponse: URLResponse) throws -> HTTPURLResponse {
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw SessionError.unauthorized
        }
        
        guard let statusCode = HTTPStatusCode(rawValue: httpResponse.statusCode) else {
            throw SessionError.unknownHTTPStatusCode
        }
        
        if statusCode.responseType != .success {
            if unauthorizedStatusCodes.contains(statusCode) {
                throw SessionError.unknownHTTPStatusCode
            }
            //HttpStatusCode is an error, thus it can be thrown.
            throw statusCode
        }
        
        return httpResponse
    }
    
    private func handleResponse<Output: Decodable>(data: Data,
                                                   urlResponse: URLResponse,
                                                   dateFormatters: [DateFormatter] )  throws -> Output {
        try validateResponse(urlResponse: urlResponse)
        let response = Response(data: data, response: urlResponse)
        let decoded = try response.decoded(Output.self,
                                           dateFormatters: dateFormatters,
                                           keyDecodingStrategy: .useDefaultKeys)
            
        
        return decoded
    }
}


extension AsyncSession : URLSessionDelegate {}

extension AsyncSession: URLSessionDataDelegate {}

extension AsyncSession:  URLSessionTaskDelegate {}

extension AsyncSession: URLSessionDownloadDelegate {
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didFinishDownloadingTo location: URL) {
            //no op.  Async methods handle this
    }
    
    public func urlSession(_ session: URLSession,
                           downloadTask: URLSessionDownloadTask,
                           didWriteData bytesWritten: Int64,
                           totalBytesWritten: Int64,
                           totalBytesExpectedToWrite: Int64) {
            
        if let progressHandler = self.progressHandler {
            var percentComplete: Double?
            if totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown {
                percentComplete = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            }
            
            DispatchQueue.main.async {
                progressHandler(bytesWritten,
                                totalBytesWritten,
                                totalBytesExpectedToWrite,
                                percentComplete)
            }
        }
    }
}
