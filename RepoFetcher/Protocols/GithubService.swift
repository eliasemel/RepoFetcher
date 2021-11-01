//
//  GithubService.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import Combine

enum GithubServiceError: Error {
	case apiError(Error)
	case unAuthoerised
	case other
}

typealias ResultPublisher<T>  =  AnyPublisher<T, GithubServiceError>

protocol GithubService {
	
	func auth(url: URL, client_id: String, client_secret: String, code: String) -> ResultPublisher<AuthDetails>
	
	/// Fetch a page of repo
	/// - Returns: Return a page of repo represented by `[RepoListItem]`
	func repoList(url: URL, token: String, pageNumber: UInt) -> ResultPublisher<[RepoListItem]>
	
}
