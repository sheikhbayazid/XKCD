//
//  ContentView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ComicViewModel()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem(viewModel.home)
            
            BrowseView()
                .tabItem(viewModel.browse)
            
            FavoritesView()
                .tabItem(viewModel.favourites)
        }
        .accentColor(.primary)
        .preferredColorScheme(.dark)
        .environmentObject(viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
