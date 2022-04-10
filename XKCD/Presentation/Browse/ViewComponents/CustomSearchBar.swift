//
//  CustomSearchBar.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/22/21.
//

import SwiftUI

struct CustomSearchBar: View {
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
                .padding(.horizontal, 15)
                .padding(.vertical, 10)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            sortMenu(sort: $viewModel.sort)
        }
    }
    
    private func clearTextField() {
        viewModel.searchText = ""
    }
}

struct CustomSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomSearchBar(viewModel: ComicViewModel())
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
