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
            navigationBar()
            
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.totalComics, id: \.self) { number in
                        ComicView(comicNumber: number)
                            .animation(.easeIn, value: viewModel.comics)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func navigationBar() -> some View {
        VStack {
            HStack {
                Text("XKCD Comics")
                    .font(.xkcd(size: 26))
                
                Spacer()
                sortMenu(sort: $viewModel.sort)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
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
