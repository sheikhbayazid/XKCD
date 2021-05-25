//
//  FavoriteComicCellView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/25/21.
//

import SwiftUI

struct FavoriteComicCellView: View {
    let item: FetchedResults<Favorite>.Element
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("#\(item.num): " + (item.title ?? ""))
                .font(.headline)
            
            Text(item.alt ?? "")
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
    }
}
