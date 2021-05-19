//
//  HomeView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel = ComicViewModel()
    
    var body: some View {
        NavigationView {
            //MARK: - Add Sorting Option - Latest / Earliest
            
            // Earliest
            //                ForEach(1...viewModel.totalComics, id: \.self) { number in
            //                    ComicTabView(comicNumber: number)
            //                }
            
            
            // Latest
            ScrollView {
                LazyVStack {
                    if viewModel.sort == 0 {
                        ForEach(Array(stride(from: viewModel.totalComics + 4, to: 1, by: -1)), id: \.self) { number in
                            ComicView(comicNumber: number)
                        }
                    } else if viewModel.sort == 1 {
                        ForEach(1...viewModel.totalComics, id: \.self) { number in
                            ComicView(comicNumber: number)
                        }
                    }
                }
                
            }
            .navigationTitle("XKCD Comics")
            .toolbar { // Sort Menu
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker(selection: $viewModel.sort, label: Text("Sorting options")) {
                            Text("Latest").tag(0)
                            Text("Earliest").tag(1)
                        }
                    }
                    label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            
            //MARK: - Add Random Comic Button
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
