//
//  FavoritesView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(entity: Favorite.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Favorite.title, ascending: true),]) var favorites: FetchedResults<Favorite>
    
    @State var image: Data = .init(count: 0)
    
    var body: some View {
        NavigationView {
            VStack {
                HeaderView()
                Spacer()
                
                // MARK: - Using List in VStack - Auto select issue when back from navigation link.
                List {
                    ForEach(favorites) { item in
                        NavigationLink(
                            destination: FavoriteDetailView(item: item),
                            
                            label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("#\(item.num): " + (item.title ?? ""))
                                        .font(.headline)
                                    
                                    Text(item.alt ?? "")
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                            })
                    }
                    .onDelete(perform: deleteComic)
                }.listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
    }
    
    
    func deleteComic(offsets: IndexSet) {
        withAnimation {
            //offsets.map { favorites[$0] }.forEach(moc.delete)
            //alternative deletion without map
            for index in offsets {
                let favorite = favorites[index]
                moc.delete(favorite)
            }
            
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch {
                    print("Error saving book: \(error.localizedDescription)")
                }
            }
        }
    }
    
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FavoritesView()
            //FavoriteDetailView()
        }
    }
}



fileprivate struct HeaderView: View {
    var body: some View {
        HStack {
            Text("Favorites")
                .font(.custom("xkcd", size: 26))
            
            Spacer()
            
            EditButton()
        }.padding(.horizontal)
        .padding(.vertical, 10)
    }
}
