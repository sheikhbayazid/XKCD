//
//  ComicCellView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicCellView: View {
    let comic: Comic
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    @State private var items: [Any] = []
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            
            if !comic.img.isEmpty {
                AsyncImage(url: URL(string: comic.img)!, placeholder: { Color.gray.opacity(0.15) }) { image in
                    Image(uiImage: image)
                        .resizable()
                }.aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .frame(maxWidth: Screen.width, maxHeight: Screen.height * 0.6)
                .pinchToZoom()
                .onTapGesture(count: 2) {
                    withAnimation(.spring()) {
                        isFavorite = true
                    }
                }
                
                
                VStack(spacing: 5) {
                    HStack {
                        Button(action: {
                            self.isShareSheetShowing = true
                            
                            items.removeAll()
                            items.append(comic.img.load())
                            
                            
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2)
                        }).sheet(isPresented: $isShareSheetShowing) {
                            ShareSheetView(items: items )
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                isFavorite.toggle()
                            }
                            
                            //MARK: - Add Favorite Comic
                        }, label: {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title2)
                        })
                        
                    }
                    
                    Divider()
                }
                .padding(.horizontal, 10)
                
                
                //                Image(uiImage: comic.img.load())
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fit)
                //                    .cornerRadius(5)
                //                    .frame(maxWidth: Screen.width, maxHeight: Screen.height * 0.6)
                //                    .pinchToZoom()
                //                    .onTapGesture {
                //                        withAnimation(.easeInOut(duration: 0.005)) {
                //                            self.isTapped.toggle()
                //                        }
                //                    }
                
                if comic.num != 0 {
                    VStack(alignment: .leading, spacing: 1) {
                        
                        Text("#\(comic.num): " + comic.title)
                            .fontWeight(.medium)
                            .font(.subheadline)
                        
                        Text(comic.alt)
                            .font(.footnote)
                    }
                    .padding(.horizontal, 10)
                }
            }
            
        }.padding(.vertical)
    }
}


struct ComicCellView_Previews: PreviewProvider {
    static var previews: some View {
        ComicCellView(comic: Comic.example)
    }
}
