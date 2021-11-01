//
//  MockUserManager.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import CoreText
import Combine

final class MockUserManager: UserManager {
	var userState: UserState {
		.nonauthenicated
	}
	
	var userStatePublisher: AnyPublisher<UserState, Never> {
		Just(.nonauthenicated).eraseToAnyPublisher()
	}
	
	func authenticateUser(code: String) {
		
	}
	
	func repoList(page: UInt) -> ResultPublisher<[RepoListItem]>? {
		return nil
	}
	
	
}
