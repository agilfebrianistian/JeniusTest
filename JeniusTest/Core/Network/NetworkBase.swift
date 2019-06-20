//
//  NetworkBase.swift
//  Network Manager Framework
//
//  Created by Agil Febrianistian on 04/02/19.
//  Copyright © 2019 agil. All rights reserved.
//

import Foundation
import Moya
import Result

typealias NetworkSuccessCompletion = (Data) -> Void
typealias NetworkErrorCompletion = (NetworkError) -> Void
typealias NetworkTarget = TargetType

class NetworkBase {
    static var networkProvider = MoyaProvider<NetworkAPI>(manager: NetworkManager.sharedInstance.manager,
                                                          plugins: [NetworkAuth()])
    
    func request<T: NetworkTarget>(target: T,
                                   success: @escaping NetworkSuccessCompletion,
                                   error: @escaping NetworkErrorCompletion) {
        switch target {
        case is NetworkAPI:
            NetworkBase.networkProvider.request(target as! NetworkAPI) { (result) in
                self.handleRequest(target: target,
                                   result: result,
                                   success: success,
                                   error: error)
            }
        default:
            assertionFailure("should not reach here")
        }
    }
    
    private func handleRequest<T: NetworkTarget>(target: T,
                                                 result: Result<Moya.Response, MoyaError>,
                                                 success: @escaping NetworkSuccessCompletion,
                                                 error: @escaping NetworkErrorCompletion) {
        switch result {
        case let .success(moyaResponse):
            let data = moyaResponse.data
            let statusCode = moyaResponse.statusCode
            
            switch statusCode {
            case 200...399:
                success(data)
            default:
                handleNetworkError(target.path, error: error, response: moyaResponse)
            }
        case let .failure(networkError):
            
            var networkErrorData = NetworkError()
            networkErrorData.message = networkError.localizedDescription
            error(networkErrorData)
        }
    }
    
    private func handleExpireSession() {
        // TODO: handle session timeout.
        // NotificationCenter.default.post(name: Notification.Name(rawValue: Observer.logoutApp.toString()), object: nil)
    }
    
    private func handleNetworkError(_ path: String,
                                    error: NetworkErrorCompletion,
                                    response: Moya.Response?) {
        let networkError = NetworkBase.generateError(with: response)
        
        if networkError.message == "Invalid authentication data." && response?.statusCode == 401 {
            handleExpireSession()
        }
        else {
            error(networkError)
        }
    }
}

extension NetworkBase {
    static func generateError(with response: Moya.Response?) -> NetworkError {
        do {
            let json = try? JSONSerialization.jsonObject(with: response?.data ?? Data(), options: [])
            print("json %@", json ?? [:])
            
            let decoder = JSONDecoder()
            let networkError = try decoder.decode(NetworkError.self, from: response?.data ?? Data())
            return networkError
        } catch {
            let dataString = String(data: response?.data ?? Data(), encoding: String.Encoding.utf8)
            var error = NetworkError()
            error.message = dataString
            return error
        }
    }
}
