//
//  DeeplinkHandler.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
enum DeeplinkError: Error {
	// Throws when the url returned is invalid
	case invalidURL
	
	case missingAuthCode
}

protocol DeeplinkHandler {
	
	/// Handles the deeplink according to specified `URL`
	func handle(url: URL) throws
}
