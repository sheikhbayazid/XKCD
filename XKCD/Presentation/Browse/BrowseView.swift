//
//  BrowseView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct BrowseView: View {
    @EnvironmentObject var viewModel: ComicViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                SearchBar(viewModel: viewModel)
                
                Group {
                    if viewModel.serverError {
                        errorMessage()
                    } else {
                        ComicsGridView(viewModel: viewModel)
                            .padding(.top, 10)
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
        BrowseView()
            .environmentObject(ComicViewModel())
            .preferredColorScheme(.dark)
    }
}
