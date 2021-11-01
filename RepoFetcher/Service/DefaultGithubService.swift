//
//  DefaultGithubService.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import CoreText
final class DefaultGithubService: GithubService {
	
	private struct Params {
		static let clientID = "client_id"
		static let clientSecret = "client_secret"
		static let code = "code"
		static let scope = "scope"
		static let page = "page"
		static let perPage = "per_page"
		static let authorization = "Authorization"
	}
	
	private struct Constants {
		static let perPageLimit = 20
		static let authScope = "repo"
	}
	
	enum RequestType {
		case get
		case post
	}
	
	//https://github.com/login/oauth/access_token
	
	// TODO: we need to handle refreshing of token but that is not possible for sample apps
	func auth(url: URL, client_id: String, client_secret: String, code: String) -> ResultPublisher<AuthDetails> {
		
		let urlRequest = set(
			url: url,
			type: .post,
			params: [
				Params.clientID: client_id,
				Params.clientSecret: client_secret,
				Params.code: code,
				Params.scope: Constants.authScope,
			])
		
		
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
				.tryMap { try self.mapUnAuth(data: $0.data, response: $0.response) }
				.decode(type: AuthDetails.self, decoder: JSONDecoder())
				.mapError { self.mapAndLog(error: $0) }
				.eraseToAnyPublisher()
	}
	
	func repoList(url: URL, token: String, pageNumber: UInt) -> ResultPublisher<[RepoListItem]> {
		
		let urlRequest = set(
			url: url,
			type: .get,
			params: [Params.page: String(pageNumber), Params.perPage: String(Constants.perPageLimit)],
			header: [Params.authorization: "token \(token)"])
		
		return URLSession.shared.dataTaskPublisher(for: urlRequest)
				.tryMap { try self.mapUnAuth(data: $0.data, response: $0.response) }
				.decode(type: [RepoListItem].self, decoder: JSONDecoder())
				.mapError { self.mapAndLog(error: $0) }
				.eraseToAnyPublisher()
	}
}

extension DefaultGithubService {
	
	func mapUnAuth(data: Data, response: URLResponse) throws -> Data  {
		if let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == 401, httpResponse.statusCode == 403 {
			
			//handle unauth
			
			throw GithubServiceError.unAuthoerised

		} else {
			return data
		}
			
	}
 	func mapAndLog(error: Error) -> GithubServiceError {
		print("error : \(error)")
		
		if let unAuthError = error as? GithubServiceError, case .unAuthoerised = unAuthError {
			return unAuthError
		} else {
			return .apiError(error)

		}
		
	}
	
	private func addCommonHeaders(urlRequest: inout URLRequest) {
		urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
	}

	
	private func set(url: URL, type: RequestType, params: [String: Any?] = [:], header: [String: String] = [:]) -> URLRequest {
		
		
		var urlRequest = URLRequest(url: url)

		switch type {
		case .get:
			if var url = URLComponents(string: url.absoluteString) {
				url.queryItems = params
					.compactMapValues { $0 as? String }
					.map { URLQueryItem(name: $0.key, value: $0.value) }
				urlRequest.url = url.url
			}

			urlRequest.httpMethod = "GET"
			
		case .post:
			urlRequest.httpMethod = "POST"
			urlRequest.httpBody = params.compactMapValues { $0 }.percentEncoded()
		}
		
		addCommonHeaders(urlRequest: &urlRequest)
		
		header.forEach {
			urlRequest.setValue($0.value, forHTTPHeaderField: $0.key)
		}
		
		return urlRequest

	}
}
