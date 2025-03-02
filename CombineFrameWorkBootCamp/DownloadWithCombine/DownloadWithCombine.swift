//
//  DownloadWithCombine.swift
//  CombineFrameWorkBootCamp
//
//  Created by Adarsh Ranjan on 02/03/25.
//

import SwiftUI
import Combine

class DownloadWithCombine: ObservableObject {
    @Published var posts: [Post] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchPosts()
    }
    
    func fetchPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background)) // Process request in background (like order processing)
            .receive(on: DispatchQueue.main) // Deliver data to main thread (like order delivery)
            .tryMap { (data, response) -> Data in //Check box is not damaged
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: [Post].self, decoder: JSONDecoder()) // check if my order is correc6t
            .replaceError(with: []) // if we dont wnana deal witth error reurn this the we will notcompletuon blokc
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching posts: \(error.localizedDescription)") // Handle errors (like a failed order)
                case .finished:
                    print("Successfully fetched posts.") // Confirm completion (like successful order delivery)
                }
            }, receiveValue: { [weak self] posts in
                self?.posts = posts // Update posts list (like delivering items)
            })
            .store(in: &cancellables) // Store subscription (like tracking an order)
    }

}

struct PostListView: View {
    @StateObject var viewModel = DownloadWithCombine()
    
    var body: some View {
        List(viewModel.posts) { post in
            VStack(alignment: .leading) {
                Text(post.title)
                    .font(.headline)
                Text(post.body)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}
