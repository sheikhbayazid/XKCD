//
//  FavoriteDetailView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI

struct FavoriteDetailView: View {
    let item: FetchedResults<Favorite>.Element
    
    @State var image: Data = .init(count: 0)
    @State private var isShareSheetShowing = false
    
    var navigationTitle: String {
        return "\(item.num) \(item.title ?? "")"
    }
    
    var shareButton: some View {
        Button(action: {
            self.isShareSheetShowing = true
            shareSheet(for: [item.image ?? UIImage()])
            
        }, label: {
            Image(systemName: "square.and.arrow.up")
                .font(.title2)
        })
    }
    
    var body: some View {
        ScrollView {
            Spacer()
            
            Image(uiImage: UIImage(data: item.image ?? self.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .pinchToZoom()
            
            DetailsView(item: item)
        }
        .padding()
        .navigationBarTitle(Text(navigationTitle), displayMode: .inline)
        .navigationBarItems(trailing: shareButton)
    }
}

// MARK: - Favorite Comic Details
fileprivate struct DetailsView: View {
    let item: FetchedResults<Favorite>.Element
    @State private var isSafariShowing = false
    
    var transcript: String {
        item.transcript ?? ""
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                Text("Go to comic")
                
                Text(" explanation")
                    .fontWeight(.medium)
                    .underline()
                    .onTapGesture {
                        self.isSafariShowing = true
                    }
            }
            .font(.subheadline)
            .padding(.top, 2)
            .fullScreenCover(isPresented: $isSafariShowing) {
                SafariView(url: URL(string: "https://www.explainxkcd.com/wiki/index.php/\(item.num)")!)
                    .ignoresSafeArea()
                    .preferredColorScheme(.dark)
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(item.alt ?? "")
                        .font(.headline)
                    
                    if !transcript.isEmpty {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Transcript:")
                                .fontWeight(.medium)
                            
                            Text("\(transcript)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .padding(.top)
        }
    }
}
