//
//  DefaultNavTests.swift
//  RepoFetcherTests
//
//  Created by Emel Elias on 2021-11-01.
//

import Foundation
import XCTest
@testable import RepoFetcher

class DefaultNavTests: XCTestCase {
	
	
	func testPush() {
		let testVC = UIViewController()
		let navController = UINavigationController()
		let defaultNav = DefaultNavigationCoordinator(navigationController: navController)
		XCTAssertNoThrow(try defaultNav.navigate(viewController: testVC, type: NavType.push, extra: nil, completion: nil))
		
		
		XCTAssertEqual(navController.viewControllers[0], testVC)
		
	}
	
	func testCompletion() {
		
		let testVC = UIViewController()
		let navController = UINavigationController()
		let defaultNav = DefaultNavigationCoordinator(navigationController: navController)
		let exp = expectation(description: "Test after 2 seconds")

		let result = XCTWaiter.wait(for: [exp], timeout: 2.0)

		var completed = false
		XCTAssertNoThrow(try defaultNav.navigate(viewController: testVC, type: NavType.push, extra: nil) {
			
			completed = true
		})
		
		if result == XCTWaiter.Result.timedOut {
			XCTAssertTrue(completed)
		} else {
			XCTFail("Delay interrupted")
		}
		
	}
	
	func testNilVC() {
		
		let navController = UINavigationController()
		let defaultNav = DefaultNavigationCoordinator(navigationController: navController)
		XCTAssertThrowsError(try defaultNav.navigate(viewController: nil, type: NavType.push, extra: nil))
			
	}

}
