//
//  DefaultUserManger.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//


import Foundation

import Combine
import KeychainSwift

enum UserState {
	case authenticated(accessToken: String)
	case nonauthenicated
	case none
}


class DefaultUserManager: UserManager {
	
	private let keychain = KeychainSwift()

	
	private struct Constants {
		static let authURL = URL(string: "https://github.com/login/oauth/access_token")!
		static let repoListURL = URL(string: "https://api.github.com/user/repos")!

		static let clientID = "6caa1240421bc01b7d8b"
		// Not the best way to store client secret but there is no alternative other than code
		static let client_secret = "020766586a2d4540eaa970c8b084054ddaca7c44"
	}
	
	var userState: UserState {
		get {
			if let token =  keychain.get("token") {
				return .authenticated(accessToken: token)
			} else {
				return .nonauthenicated
			}

		}
		set {
			if case .authenticated(let token) = newValue {
				keychain.set(token, forKey: "token")

			}
			_userStatePublisher.send(newValue)
		}
	}
	
	private let service: GithubService
	
	private var authPublisher: AnyCancellable?
	
	/// Publishes the most recent user identity.
	var userStatePublisher: AnyPublisher<UserState, Never> {
		_userStatePublisher.eraseToAnyPublisher()
	}
	
	private let _userStatePublisher = CurrentValueSubject<UserState, Never>(.none)


	
	init(service: GithubService) {
		self.service = service
	}
	
	func authenticateUser(code: String) {
		
		guard case .nonauthenicated = userState else {
			return
		}
		
		authPublisher = service.auth(
			url: Constants.authURL,
			client_id: Constants.clientID,
			client_secret: Constants.client_secret,
			code: code).sink(receiveCompletion: { [weak self] completion in
				
				switch completion {
				case .failure(let error):
					print("Error \(error)")
					if  case .unAuthoerised = error {
						
						// clear the key
						self?.logout()
					}
					
				case .finished: print("Publisher is finished")
				}
			
		}, receiveValue: { [weak self] details in
			print("access token :: \(details.access_token)")
			
			self?.userState = .authenticated(accessToken: details.access_token)
			
		})
		
	}
	
	
	func repoList(page: UInt) -> ResultPublisher<[RepoListItem]>? {
		if case .authenticated(let token) = userState {
			return service.repoList(url: Constants.repoListURL, token: token, pageNumber: page).mapError { [weak self] error in
				if  case .unAuthoerised = error {
					
					// clear the key
					self?.logout()
				}
				return error
			}.eraseToAnyPublisher()
		} else {
			return nil
		}
	}
	
	private func logout() {
		// clear the key chain
		self.keychain.clear()
		self.userState = .nonauthenicated
	}
}
