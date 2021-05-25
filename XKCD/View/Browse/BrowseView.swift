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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                NavSearchBarView(viewModel: viewModel)
                
                Spacer()
                
                ZStack {
                    ScrollView {
                        // Loading all comics lazily
                        LazyVGrid(columns: columns) {
                            BrowseComicsView(viewModel: viewModel)
                        }
                    }
                    
                    // Showing error message if there's any server/decoding failure
                    if viewModel.serverError {
                        ErrorMessage()
                    }
                }
                
            }
            .navigationBarHidden(true)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ErrorMessage()
                .padding()
                .previewLayout(.sizeThatFits)
            
            BrowseView(viewModel: ComicViewModel())
        }
    }
}

struct ErrorMessage: View {
    var body: some View {
        Text("Something went wrong. Please try again later.")
            .fontWeight(.medium)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.horizontal)
    }
}
