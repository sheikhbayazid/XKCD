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
    @State private var isSafariShowing = false
    
    var body: some View {
        ScrollView {
            Spacer()
            
            Image(uiImage: UIImage(data: item.image ?? self.image)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .pinchToZoom()
            
            VStack(alignment: .center, spacing: 20) {
                comicExplanationView()
                altAndTranscriptView()
            }
        }
        .padding()
        .navigationBarTitle(Text(navigationTitle), displayMode: .inline)
        .navigationBarItems(trailing: shareButton())
    }
    
    @ViewBuilder
    private func shareButton() -> some View {
        Button(action: openShareSheet) {
            Image(systemName: "square.and.arrow.up")
                .font(.title2)
        }
    }
    
    @ViewBuilder
    private func comicExplanationView() -> some View {
        HStack(spacing: 0) {
            Text("Go to comic")
            
            Text(" explanation")
                .fontWeight(.medium)
                .underline()
                .onTapGesture(perform: showSafari)
        }
        .font(.subheadline)
        .padding(.top, 2)
        .fullScreenCover(isPresented: $isSafariShowing) {
            SafariView(url: URL(string: "https://www.explainxkcd.com/wiki/index.php/\(item.num)")!)
                .ignoresSafeArea()
                .preferredColorScheme(.dark)
        }
    }
    
    @ViewBuilder
    private func altAndTranscriptView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(item.alt ?? "")
                    .font(.headline)
                
                if item.transcript != nil {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Transcript:")
                            .fontWeight(.medium)
                        
                        Text(item.transcript ?? "")
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
    }
    
    private var navigationTitle: String {
        return "\(item.num) \(item.title ?? "")"
    }
    
    private func openShareSheet() {
        shareSheet(for: [item.image ?? UIImage()])
    }
    
    private func showSafari() {
        self.isSafariShowing = true
    }
}
