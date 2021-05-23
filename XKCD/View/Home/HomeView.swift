//
//  HomeView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: ComicViewModel
    @State private var comic = Comic.example
    
    @Environment(\.managedObjectContext) private var moc
    
    //    init() {
    //        UINavigationBar.appearance().largeTitleTextAttributes = [.font : UIFont(name: "xkcd", size: 30)!]
    //        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "xkcd", size: 20)!]
    //
    //    }
    
    var comics: Array<Int> {
        if viewModel.sort == 0 {
            return Array(stride(from: viewModel.totalComics, to: 1, by: -1))
        } else if viewModel.sort == 1 {
            return Array(1...viewModel.totalComics)
        }
        
        return Array(stride(from: viewModel.totalComics, to: 1, by: -1))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HeaderView(viewModel: viewModel)
            
            Divider()
            
            ScrollView {
                LazyVStack {
                    ForEach(comics, id: \.self) { number in
                        ComicView(comicNumber: number)
                            .environment(\.managedObjectContext, self.moc)
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


fileprivate struct HeaderView: View {
    @ObservedObject var viewModel: ComicViewModel
    
    var body: some View {
        HStack {
            Text("XKCD Comics")
                .font(.custom("xkcd", size: 26))
            
            Spacer()
            
            Menu {
                Picker(selection: $viewModel.sort, label: Text("Sorting options")) {
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
        
    }
}
