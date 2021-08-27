//
//  ContentView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewModel = ComicViewModel()
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem(viewModel.home)
            
            BrowseView(viewModel: viewModel)
                .tabItem(viewModel.browse)
            
            FavoritesView()
                .tabItem(viewModel.favourites)
        }
        .accentColor(.primary)
        .preferredColorScheme(.dark)
        .environment(\.managedObjectContext, self.moc)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}
