//
//  UserManager.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import Combine
protocol UserManager {
	/// Provides synchronous access to the current user details
	var userState: UserState { get }
	var userStatePublisher: AnyPublisher<UserState, Never> { get }
	func authenticateUser(code: String)
	
	
	/// Gets the repo list of a user
	/// - Returns: The repos
	func repoList(page: UInt) -> ResultPublisher<[RepoListItem]>?
}
