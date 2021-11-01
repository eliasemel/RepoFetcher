//
//  ListViewModel.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import Combine




typealias RepoListState = LoadState<[RepoListItem]>

final class ListViewModel {
	
	private var currentPage: UInt = 1
	
	private(set) var userManager: UserManager
	
	private var repoListPublisher: AnyCancellable?
	
	let navigationCoordinator: NavigationCoordinator
	
	
	@Published var state: RepoListState = .empty
	
	
	init(userManager: UserManager, navigationCoordinator: NavigationCoordinator) {
		
		self.userManager = userManager
		self.navigationCoordinator = navigationCoordinator
	}
	
	
	/// Fetch the `ContentPage` for particular URL
	/// - Parameter url: The url to fetch
	func fetchRepos() {
		
		
		
		state = .loading
		
		repoListPublisher = self.userManager.repoList(page: self.currentPage)?
			.receive(on: RunLoop.main)
			.sink { [weak self] completion in
				switch completion {
					case .failure(let error):
					self?.state = .failure(error)
					case .finished:
					print("Publisher is finished")
				}
			} receiveValue: { [weak self] page in
				guard let self = self else {
					return
				}
				self.state = .loaded(page)
				self.currentPage = self.currentPage + 1
				
			}
	}
	
	
	/// Fetches the next `ContentPage`
	func nextPage() {
		
		guard case .loaded(let repoList) = state, !repoList.isEmpty else {
			return
		}
		
		fetchRepos()
		
	}

}
	
	
