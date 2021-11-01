//
//  DefaultNavigationCoordinator.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import UIKit

enum NavError: Error {
	case vcNotFound
}
final class DefaultNavigationCoordinator: NavigationCoordinator {
	

	
	private let rootNavigationController: UINavigationController
	
	init(navigationController: UINavigationController) {
		self.rootNavigationController = navigationController
	}
	
	func navigate(viewController: UIViewController?, type: NavType, extra: Any?, completion: (() -> Void)?) throws {
		

		switch type {
		case .push:
			guard let vc = viewController else {
				throw NavError.vcNotFound
			}
			self.rootNavigationController.pushViewController(vc, animated: true)
			completion?()
		case .present:
			guard let vc = viewController else {
				throw NavError.vcNotFound

			}
			self.rootNavigationController.present(vc, animated: true, completion: completion)
		case .externalBrowser:
			
			guard let urlString = extra as? String ,
				  let url = URL(string: urlString) else { return }
			UIApplication.shared.open(url)
		}
	}
	
}
