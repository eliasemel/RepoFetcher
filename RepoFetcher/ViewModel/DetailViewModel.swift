//
//  DetailViewModel.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import Combine


class DetailViewModel: ObservableObject {
	
	private let repoListItem: RepoListItem
	
	@Published var state: LoadState<RepoListItem> = .loading
		
	private var repoDetailsPublisher: AnyCancellable?
	
	private let userManager: UserManager
	
	init(repoListItem: RepoListItem, userManager: UserManager) {
		self.userManager = userManager
		self.repoListItem = repoListItem
		
		self.state = .loaded(repoListItem)


	}
}
