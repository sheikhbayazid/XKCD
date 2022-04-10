//
//  FavoriteDetailView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/23/21.
//

import SwiftUI
import CoreData

struct FavoriteDetailView: View {
    let item: Favorite
    
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
        HStack(spacing: 5) {
            Text("Go to comic")
            
            Text("explanation")
                .underline(true, color: .yellow)
                .fontWeight(.medium)
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
                
                if item.transcript != nil && item.transcript!.count > 10 {
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
        .grayBackgrund()
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

struct FavoriteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        return FavoriteDetailView(item: Favorite(context: context))
    }
}
