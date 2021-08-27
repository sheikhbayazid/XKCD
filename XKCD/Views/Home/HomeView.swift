//
//  HomeView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ComicViewModel
    
    var comics: [Int] {
        if viewModel.sort == 0 {
            return Array(stride(from: viewModel.totalComics, to: 1, by: -1)) // Latest comics
        } else if viewModel.sort == 1 {
            return Array(1...viewModel.totalComics) // Earliest comics
        }
        return Array(stride(from: viewModel.totalComics, to: 1, by: -1)) // Default latest comics
    }
    
    var body: some View {
        VStack(spacing: 10) {
            CustomNavigationBar(sort: $viewModel.sort)
            
            ScrollView {
                LazyVStack {
                    ForEach(comics, id: \.self) { number in
                        ComicView(comicNumber: number)
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: ComicViewModel())
            .preferredColorScheme(.dark)
    }
}
