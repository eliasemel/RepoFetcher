//
//  LoadState.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-29.
//

import Foundation

/// Different Load states for UI
enum LoadState<Content> {
	case empty
	case loading
	case loaded(Content)
	case failure(GithubServiceError)
}
