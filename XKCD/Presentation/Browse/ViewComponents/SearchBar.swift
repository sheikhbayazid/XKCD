//
//  SearchBar.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/22/21.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var viewModel: ComicViewModel
    
    var body: some View {
        HStack {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    
                    TextField("Title, number, transcript, alt etc.", text: $viewModel.searchText)
                    
                    if !viewModel.searchText.isEmpty {
                        Button(action: clearTextField ) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .grayBackgrund()
            }
            
            sortMenu(sort: $viewModel.sort)
        }
    }
    
    private func clearTextField() {
        viewModel.searchText = ""
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(viewModel: ComicViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
