//
//  MockGithubService.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import Combine

final class MockGithubService: GithubService {
	
	func auth(url: URL, client_id: String, client_secret: String, code: String) -> ResultPublisher<AuthDetails> {
			Just(.init(access_token: "dsvsfdgfdr"))
				.setFailureType(to: GithubServiceError.self)
				.eraseToAnyPublisher()
		
	}
	
	
	
	func repoList(url: URL, token: String, pageNumber: UInt) -> ResultPublisher<[RepoListItem]> {
		
		Just([
			.init(id: 123, name: "Emel 1", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),
			.init(id: 123, name: "Emel 2", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),
			.init(id: 123, name: "Emel 3", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),
			.init(id: 123, name: "Emel 4", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),
			.init(id: 123, name: "Emel 5", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),
			.init(id: 123, name: "Emel 6", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),
			.init(id: 123, name: "Emel 7", full_name: "full name", description: "test disc", html_url: "https://www.dummy.com"),])
			.setFailureType(to: GithubServiceError.self)
			.eraseToAnyPublisher()
		
	}
		
}

