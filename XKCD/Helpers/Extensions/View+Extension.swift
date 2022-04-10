//
//  View+Extension.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 10/4/22.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    func sortMenu(sort: Binding<Sort>) -> some View {
        Menu {
            Picker(selection: sort, label: Text("Filter options")) {
                Text("Latest").tag(Sort.latest)
                Text("Earliest").tag(Sort.earliest)
            }
        } label: {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .font(.title)
        }
    }
    
    @ViewBuilder
    func imageView(url: String) -> some View {
        AsyncImage(url: URL(string: url)!, placeholder: loadingView) {
            Image(uiImage: $0)
                .resizable()
        }
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .pinchToZoom()
    }
    
    @ViewBuilder
    func loadingView() -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            ProgressView()
        }
    }
    
    @ViewBuilder
    func grayBackgrund() -> some View {
        self
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    func errorMessage() -> some View {
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
