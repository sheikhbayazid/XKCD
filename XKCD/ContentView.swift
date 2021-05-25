//
//  ContentView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import SwiftUI

// browse through the comics,
// see the comic details, including its description,
// search for comics by the comic number as well as text,
// get the comic explanation
// favorite the comics, which would be available offline too,
// send comics to others,
// get notifications when a new comic is published,
// support multiple form factors.

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewModel = ComicViewModel()
    
    var body: some View {
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "rectangle.3.offgrid.bubble.left")
                    Text("Comics")
                }
            
            BrowseView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                    Text("Browse")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
        }.accentColor(.primary)
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
