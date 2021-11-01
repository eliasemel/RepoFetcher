//
//  ListingViewController.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import UIKit
import Combine
import SwiftUI

private struct Constants {
	static let RepoCollectionViewCellReuseIdentifier = "RepoCollectionViewCellIndentifier"
	static let footerReuseIdentifier = "footerReuseIdentifier"
}

class ListingViewController: UIViewController {
	
	
	private let repoCollectionView: UICollectionView
	
	let model: ListViewModel
	
	private var repos: [RepoListItem] = []
	
	private var statePublisher: AnyCancellable?
	
	
	
	private let footerView = UIActivityIndicatorView(style: .large)


	
	init(model: ListViewModel) {
		
		
		self.model = model
		
		let layout = UICollectionViewFlowLayout()
		self.repoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		
		super.init(nibName: nil, bundle: nil)
		
		
		layout.itemSize = .init(width: self.view.bounds.width, height: 60.0)
		layout.scrollDirection = .vertical
		
		
		self.repoCollectionView.register(
			RepoCollectionViewCell.self,
			forCellWithReuseIdentifier: Constants.RepoCollectionViewCellReuseIdentifier)
		
		self.repoCollectionView.register(
			UICollectionReusableView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
			withReuseIdentifier: Constants.footerReuseIdentifier)
		
		layout.footerReferenceSize = CGSize(width: self.repoCollectionView.bounds.width, height: 100)
		
		self.repoCollectionView.dataSource = self
		self.repoCollectionView.delegate = self
		
		statePublisher = self.model.$state
			.sink { [weak self] state in
				switch state {
				case .failure(let error):
					print("error \(error)")
					self?.footerView.stopAnimating()
				case .loaded(let page):
					self?.repos += page
					self?.repoCollectionView.reloadData()
					self?.footerView.stopAnimating()
				case .empty:
					print("")
				case .loading:
					print("loading..")
					self?.footerView.startAnimating()
				}
		}
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureUI()
		model.fetchRepos()

	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
	}
		
	private func configureUI() {

		self.view.backgroundColor = .white
		
		self.repoCollectionView.backgroundColor = .white
		
		self.navigationItem.title = "My Repos"
		
		self.view.autoLayoutAddSubview(childView: self.repoCollectionView)
		self.view.addConstraintsToFill(childView: self.repoCollectionView)
	}
}

extension ListingViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		
		if indexPath.row == repos.count - 1 {
			nextPage()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		do {
			let selectedRepo = repos[indexPath.row]
			
			let detailVC =  UIHostingController(rootView: DetailView(model: .init(repoListItem: selectedRepo, userManager: model.userManager)))

			try model.navigationCoordinator.navigate(viewController: detailVC,type: .push, extra: selectedRepo)
			
		} catch let error {
			print("error \(error)")
		}
		
	}
	
}

extension ListingViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return repos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.RepoCollectionViewCellReuseIdentifier, for: indexPath) as! RepoCollectionViewCell
		
		
		cell.setContent(repList: repos[indexPath.row])
		
		return cell
	}
	
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
			if kind == UICollectionView.elementKindSectionFooter {
				let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.footerReuseIdentifier, for: indexPath)
				footer.addSubview(footerView)
				footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
				return footer
			}
			return UICollectionReusableView()
		}
	
	
}



extension ListingViewController: Pagable {
	func nextPage() {
		model.nextPage()
	}
}


class RepoCollectionViewCell: UICollectionViewCell {
	
	private lazy var label: UILabel = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	private func commonInit() {
		
		self.contentView.backgroundColor = .black
	
		self.contentView.autoLayoutAddSubview(childView: label)
		self.contentView.positionCenter(childView: label)
		
		label.textColor = .white
		
	}
	
	public func setContent(repList: RepoListItem) {
		self.label.text = repList.name
	}

}
