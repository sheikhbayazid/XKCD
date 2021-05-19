//
//  ComicDetailsView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct ComicDetailsView: View {
    let comic: ComicResponse
    var imageURL = ""
    
    @State private var isSheetShowing = false
    
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    @State private var items: [Any] = []
    
    init(comic: ComicResponse) {
        self.comic = comic
        
        for image in comic.imgs {
            imageURL = image.sourceUrl
        }
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageURL)!, placeholder: { Color.gray.opacity(0.15) }) { image in
                Image(uiImage: image)
                    .resizable()
            }.aspectRatio(contentMode: .fit)
            .frame(maxWidth: Screen.width, maxHeight: Screen.height * 0.75)
            .pinchToZoom()
            
            
            
            //            Image(uiImage: imageURL.load())
            //                .resizable()
            //                .aspectRatio(contentMode: .fit)
            //                .cornerRadius(5)
            //                .animation(.default)
            //                .frame(maxWidth: Screen.width, maxHeight: Screen.height * 0.75)
            //                .pinchToZoom()
            
            Text(comic.alt)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: {
                self.isSheetShowing = true
            }, label: {
                HStack {
                    Text("Go to")
                    Text("Comic explanation")
                        .underline()
                        .foregroundColor(.blue)
                    
                    Spacer()
                }.font(.footnote)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
                .padding()
            })
            .sheet(isPresented: $isSheetShowing) {
                SafariView(url: URL(string: comic.explainUrl)!)
            }
            
            
        }.padding(.horizontal)
        .navigationBarTitle(Text(comic.title), displayMode: .inline)
        .navigationBarItems(
            trailing:
                HStack {
                    Button(action: {
                        self.isShareSheetShowing = true
                        
                        items.removeAll()
                        items.append(imageURL.load())
                        
                        
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.blue)
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
                            .foregroundColor(.red)
                    })
                }
        )
        
        
    }
}

struct ComicDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetailsView(comic: ComicResponse.example)
    }
}
