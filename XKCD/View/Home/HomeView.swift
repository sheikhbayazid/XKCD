//
//  HomeView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ComicViewModel
    
    var comics: Array<Int> {
        if viewModel.sort == 0 {
            return Array(stride(from: viewModel.totalComics, to: 1, by: -1)) // Latest comics
        } else if viewModel.sort == 1 {
            return Array(1...viewModel.totalComics) // Earliest comics
        }
        return Array(stride(from: viewModel.totalComics, to: 1, by: -1)) // Default latest comics
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView(viewModel: viewModel)
            
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
        Group {
            HeaderView(viewModel: ComicViewModel())
                .previewLayout(.sizeThatFits)
            
            HomeView(viewModel: ComicViewModel())
                .preferredColorScheme(.dark)
        }
    }
}

fileprivate struct HeaderView: View {
    @ObservedObject var viewModel: ComicViewModel
    
    var body: some View {
        VStack {
            HStack {
                Text("XKCD Comics")
                    .font(.custom("xkcd", size: 26))
                
                Spacer()
                
                // Filter/Sort menu button
                Menu {
                    Picker(selection: $viewModel.sort, label: Text("Filter options")) {
                        Text("Latest").tag(0)
                        Text("Earliest").tag(1)
                    }
                }
                label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}
