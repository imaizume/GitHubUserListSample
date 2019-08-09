//
//  WebAPI.swift
//  GitHubUserListSample
//
//  Created by 今泉 智博 on 2019/07/30.
//  Copyright © 2019 imaizume. All rights reserved.
//

import Foundation

enum WebAPI {
    static func call(with input: Input, _ block: @escaping (Output) -> Void) {
        let urlRequest = self.createURLRequest(by: input)

        print("[REQUEST] URL:\(urlRequest.url!.absoluteString)")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, urlResponse, error) in
            let output: Output = self.createOutput(
                data: data,
                urlResponse: urlResponse as? HTTPURLResponse,
                error: error
            )

            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                print(String(decoding: jsonData, as: UTF8.self))
            } else {
                print("json data malformed")
            }

            block(output)
        }

        task.resume()
    }

    private static func createURLRequest(by input: Input) -> URLRequest {

        var urlComponents: URLComponents! = URLComponents(string: input.urlString)
        urlComponents.queryItems = input.queries

        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = input.methodAndPayload.method
        request.httpBody = input.methodAndPayload.body
        request.allHTTPHeaderFields = input.headers

        return request
    }

    private static func createOutput(
        data: Data?,
        urlResponse: HTTPURLResponse?,
        error: Error?) -> Output {

        guard let data = data, let response = urlResponse else {
            return .noResponse(.noDataOrNoResponse(debugInfo: error.debugDescription))
        }

        var headers: [String: String] = [:]
        for (key, value) in response.allHeaderFields.enumerated() {
            headers[key.description] = String(describing: value)
        }
        return .hasResponse((
            statusCode: .from(code: response.statusCode),
            headers: headers,
            payload: data
        ))
    }
}
