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
                CustomSearchBar(viewModel: viewModel)
                
                Group {
                    if viewModel.serverError {
                        errorMessage()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns) {
                                BrowseComicsView(viewModel: viewModel)
                            }
                        }
                    }
                }
                
            }
            .navigationBarHidden(true)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
    
    @ViewBuilder
    private func errorMessage() -> some View {
        Group {
            Spacer()
            
            Text("Something went wrong. Please try again later.")
                .fontWeight(.medium)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
        }
    }
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView(viewModel: ComicViewModel())
    }
}
