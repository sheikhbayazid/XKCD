//
//  HomeView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: ComicViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            CustomNavigationBar(sort: $viewModel.sort)
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.totalComics, id: \.self) { number in
                        ComicView(comicNumber: number)
                    }
                }
            }
            .animation(.easeIn, value: viewModel.comics)
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
