//
//  HomeView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ComicViewModel
    
    var comics: [Int] {
        if viewModel.sort == .latest {
            return Array(stride(from: viewModel.totalComics, to: 1, by: -1))
        } else if viewModel.sort == .earliest {
            return Array(1...viewModel.totalComics)
        }
        return Array(stride(from: viewModel.totalComics, to: 1, by: -1))
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
        HomeView()
            .environmentObject(ComicViewModel())
            .preferredColorScheme(.dark)
    }
}
