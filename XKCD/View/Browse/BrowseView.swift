//
//  BrowseView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct BrowseView: View {
    @ObservedObject var viewModel: ComicViewModel
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    @Environment(\.managedObjectContext) private var moc
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                NavBarView(viewModel: viewModel)
                
                Spacer()
                
                if viewModel.serverError {
                    ErrorMessageView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns) {
                            BrowseComicsView(viewModel: viewModel)
                                .environment(\.managedObjectContext, self.moc)
                        }
                    }
                    .padding(.top, 1) // To stop scrolling flickering
                }
            }.navigationBarHidden(true)
            .padding()
        }
    }
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView(viewModel: ComicViewModel())
    }
}


struct ErrorMessageView: View {
    var body: some View {
        Text("Something went wrong. Please try again later.")
            .fontWeight(.medium)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.top, 60)
    }
}
