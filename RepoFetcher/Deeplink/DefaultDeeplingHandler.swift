//
//  DefaultDeeplingHandler.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import Combine


final class DefaultDeeplinkHandler: DeeplinkHandler {
	
	private struct Constants {
		static let supportedSchemes = Set(["repofetcher"])
		static let code = "code"
	}
	
	let navigationCoordinator: NavigationCoordinator
	
	
	private var authPublisher: AnyCancellable?
	
	let userManager: UserManager
	
	init(navigationCoordinator: NavigationCoordinator, userManager: UserManager) {
		self.navigationCoordinator = navigationCoordinator
		self.userManager = userManager
	}
	func handle(url: URL) throws {
		print("detected url \(url.absoluteString)")
		
		guard let components = URLComponents(string: url.absoluteString),
			  let scheme = components.scheme,
			  Constants.supportedSchemes.contains(scheme) else {
			throw DeeplinkError.invalidURL
		}
		
		guard let authCode = components.queryItems?.first(where: { $0.name == Constants.code })?.value else {
			throw DeeplinkError.missingAuthCode
		}
		
		userManager.authenticateUser(code: authCode)
		
	}
}
