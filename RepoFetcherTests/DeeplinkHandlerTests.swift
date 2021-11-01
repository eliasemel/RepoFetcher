//
//  DeeplinkHandlerTests.swift
//  RepoFetcherTests
//
//  Created by Emel Elias on 2021-11-01.
//

import Foundation
import XCTest
@testable import RepoFetcher

class DeeplinkHandlerTests: XCTestCase {
	let defaultDeeplinkHanler = DefaultDeeplinkHandler(navigationCoordinator: MockNavigationCoordinator(), userManager: MockUserManager())
	
	func testInvalidURI() {
		
		XCTAssertThrowsError(try defaultDeeplinkHanler.handle(url: URL(string: "http://test.cc")!), "repofetcher scheme is only handled")
		
	}
	
	
	func testValidURI() {
		
		XCTAssertNoThrow(try defaultDeeplinkHanler.handle(url: URL(string: "repofetcher://test.cc?code=1234")!), "valid scheme")
		
	}
	
	func testMissingCode() {
		
		XCTAssertThrowsError(try defaultDeeplinkHanler.handle(url: URL(string: "repofetcher://test.cc")!), "valid scheme")
		
	}
}

