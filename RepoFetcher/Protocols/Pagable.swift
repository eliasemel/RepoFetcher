//
//  Pagable.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation

/// Implementors of `Pagable`should support Pagination
protocol Pagable {
	
	/// Fetches the next `ContentPage`
	func nextPage()
}
