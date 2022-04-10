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
    func loadingView() -> some View {
        ZStack {
            Color.gray.opacity(0.15)
            ProgressView()
        }
    }
    
    @ViewBuilder
    func grayBackgrund() -> some View {
        self
        .padding(16)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}
