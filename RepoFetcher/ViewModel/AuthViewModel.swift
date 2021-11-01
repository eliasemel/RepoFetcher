//
//  AuthViewModel.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import SafariServices

final class AuthViewModel {
	
	private let navigationCoordinator: NavigationCoordinator
	
	init(navigationCoordinator: NavigationCoordinator) {
		self.navigationCoordinator = navigationCoordinator
	}
	
	struct Constants {
		static let redirectURL = "https://github.com/login/oauth/authorize?client_id=6caa1240421bc01b7d8b"
	}
	
	
	/// Redirects to OAuth provider
	func redirect() {
		do {
			try navigationCoordinator.navigate(type: .externalBrowser, extra: Constants.redirectURL) {
				print("shown safari VC!!")
			}
		} catch let error {
			print("cannot redirect to web page with error :: \(error)")
		}
		
	}
	
}
