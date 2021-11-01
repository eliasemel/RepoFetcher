//
//  SceneDelegate.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-30.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	
	
	
	private var userStatePublisher: AnyCancellable?
	
	let githubService: GithubService = DefaultGithubService()
	
	let rootNavController =  UINavigationController()
	
	private lazy var  navigationCoordinator: NavigationCoordinator = DefaultNavigationCoordinator(navigationController: rootNavController)
	
	
	private lazy var userManager = DefaultUserManager(service: githubService)

	
	private lazy var deepLinkHandler: DeeplinkHandler = DefaultDeeplinkHandler(
		navigationCoordinator: navigationCoordinator,
		userManager: userManager)




	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

		
		guard let windowScene = scene as? UIWindowScene else {
			return
		}
		
		let window = UIWindow(windowScene: windowScene)
		
		
		// Handling killed state

		if let urlContext = connectionOptions.urlContexts.first {

		   let url = urlContext.url
		   do {
			   try deepLinkHandler.handle(url: url)
		   } catch let error {
			  print("error \(error)")
		   }

		   // Process the URL similarly to the UIApplicationDelegate example.
	   } else {
		   self.switchRootVC(on: userManager.userState)
	   }
		
		window.rootViewController = rootNavController
		self.window = window
		window.makeKeyAndVisible()
		
		userStatePublisher = userManager.userStatePublisher
			.receive(on: RunLoop.main)
			.dropFirst()
			.sink { [weak self] state in
				guard let self = self else {
					return
				}
				self.switchRootVC(on: state)
			}
	}
	
	
	private func switchRootVC(on state: UserState) {
		
		if case .authenticated(_) = state {
			
			let listVC = ListingViewController(model: .init(userManager: userManager, navigationCoordinator: navigationCoordinator))
			
			self.rootNavController.setViewControllers([listVC], animated: false)
			
		} else {
			let authVC =  UIHostingController(rootView: AuthView(model: .init(navigationCoordinator: self.navigationCoordinator)))
			
			self.rootNavController.setViewControllers([authVC], animated: false)
			
			
		}
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.
	}
	
	
	func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
		
		guard let url = URLContexts.first?.url  else {
			return
		}
		do {
			try deepLinkHandler.handle(url: url)
		} catch let error {
		   print("error \(error)")
		}

	}


}

