//
//  ContentView.swift
//  CombineFrameWorkBootCamp
//
//  Created by Adarsh Ranjan on 02/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DownloadWithCombine()
    
    var body: some View {
        NavigationView {
            PostListView(viewModel: viewModel)
                .navigationTitle("Posts")
        }
    }
}
