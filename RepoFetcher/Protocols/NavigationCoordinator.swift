//
//  NavigationCoordinator.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import UIKit

enum NavType {
	// pushes to current VC
	case push
	// presents
	case present
	
	// navigate to external browser
	case externalBrowser
}

protocol NavigationCoordinator {

	func navigate(viewController: UIViewController?, type: NavType, extra: Any?, completion: (() -> Void)?) throws
}


extension NavigationCoordinator {
	func navigate(viewController: UIViewController? = nil, type: NavType, extra: Any? = nil, completion: (() -> Void)? = nil) throws {
	
		try navigate(viewController: viewController, type: type, extra: extra, completion: completion)
	}

}
