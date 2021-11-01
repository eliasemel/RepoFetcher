//
//  RepoListItem.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.

import Foundation

/// Represents a item in repo's list
struct RepoListItem: Decodable {
	let id: Double
	let name: String
	let full_name: String
	let description: String?
	let html_url: String?
}


