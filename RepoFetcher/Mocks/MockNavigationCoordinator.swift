//
//  MockNavigationCoordinator.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import UIKit
final class MockNavigationCoordinator: NavigationCoordinator {

	func navigate(viewController: UIViewController?, type: NavType, extra: Any?, completion: (() -> Void)?) throws {
		
		print("mock navigation executed")
		
	}

}
