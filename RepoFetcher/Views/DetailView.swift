//
//  DetailView.swift
//  RepoFetcher
//
//  Created by Emel Elias on 2021-09-28.
//

import Foundation
import SwiftUI
import AlamofireImage
import WebKit

struct DetailView: View {
	
	@ObservedObject private(set) var model: DetailViewModel
	
	public init(model: DetailViewModel) {
		self.model = model
	}
	
	var body: some View {
		
		VStack {
			Spacer()
			HStack {
				Spacer()
				mainView(state: model.state)
				Spacer()
			}
			Spacer()
		}
		.background(Color.white)
	}
	
	private func mainView(state: LoadState<RepoListItem>) -> AnyView {
		switch state {
			
		case .loaded(let repoListItem):
			return AnyView(repoView(repoListItem: repoListItem))
		case .failure:
			return AnyView(Text("oops something went wrong!!!"))
		case .empty, .loading:
			return AnyView(ProgressView().frame(width: 100, height: 100))
			
		}
	}
	
	private func repoView(repoListItem: RepoListItem) -> some View {
		
		HStack {
			Spacer()
			VStack {
				Spacer()
				Text(repoListItem.name).font(.headline).padding()
				if let fullName = repoListItem.full_name {
					Text(fullName).font(.footnote).padding()

				}
				if let description = repoListItem.description {
					Text(description).font(.callout).padding()

				}
				if let htmlURL = repoListItem.html_url,  let url = URL(string: htmlURL) {
					Webview(url: url)

				}

				Spacer()

				
			}
			
			Spacer()
		}
		
	}
	
}

struct Webview: UIViewRepresentable {
	let url: URL

	func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
		let webview = WKWebView()

		let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
		webview.load(request)

		return webview
	}

	func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
		let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
		webview.load(request)
	}
}


struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			DetailView(model: .init(repoListItem: .init(
				id: 123,
				name: "test",
				full_name: "full name",
				description: "test",
				html_url: "https://google.com"), userManager: MockUserManager()))
				.previewLayout(PreviewLayout.sizeThatFits)
				.padding()
			.previewDisplayName("Default preview")
		}
	}
}



