//
//  AuthView.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-10-31.
//

import Foundation
import SwiftUI

struct AuthView: View {
	let model: AuthViewModel
	var body: some View {
		VStack {
			Spacer()
			HStack {
				Spacer()
				Button("Login with Github") {
					model.redirect()
				}
				.padding(.all, 20)
				.foregroundColor(.white)
				.background(Color.blue)
				Spacer()
			}
			Spacer()
		}
		.background(Color.white)
	}
}


struct AuthView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			AuthView(model: .init(navigationCoordinator: MockNavigationCoordinator()))
		}
	}
}
