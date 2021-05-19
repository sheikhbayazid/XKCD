//
//  BrowseView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/20/21.
//

import SwiftUI

struct BrowseView: View {
    @ObservedObject var viewModel = ComicViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 5) {
                    HStack {
                        TextField("Search Comic by name, number etc.", text: $viewModel.searchText)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        
                        Menu {
                            Picker(selection: $viewModel.sort, label: Text("Sort by")) {
                                Text("Latest").tag(0)
                                Text("Earliest").tag(1)
                            }
                        }
                        label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                        
                    }.padding(.horizontal)
                    
                    Spacer()
                    
                    LazyVGrid(columns: columns) {
                        if viewModel.sort == 0 {
                            ForEach(viewModel.comicResponse.sorted().reversed().filter({ viewModel.searchText.isEmpty ? true : $0.title.lowercased().contains(viewModel.searchText.lowercased()) || String($0.id).contains((viewModel.searchText)) || String($0.alt.lowercased()).contains((viewModel.searchText.lowercased())) })) { comic in
                                
                                
                                NavigationLink(
                                    destination: ComicDetailsView(comic: comic),
                                    label: {
                                        
                                        AsyncImage(url: URL(string: getImageURL(imgs: comic.imgs))!, placeholder: { Color.gray.opacity(0.15) }) { image in
                                            Image(uiImage: image)
                                                .resizable()
                                        }.aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: Screen.width / 3 - 10)
                                        .overlay(
                                            Text("\(comic.id)")
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 3)
                                                .background(Color.gray.opacity(0.75))
                                                .clipShape(Capsule())
                                                .padding(5)
                                            
                                            , alignment: .topLeading
                                        )
                                        
                                    })
                            }
                        } else if viewModel.sort == 1 {
                            ForEach(viewModel.comicResponse.sorted().filter({ viewModel.searchText.isEmpty ? true : $0.title.lowercased().contains(viewModel.searchText.lowercased()) || String($0.id).contains((viewModel.searchText)) || String($0.alt.lowercased()).contains((viewModel.searchText.lowercased())) })) { comic in
                                
                                
                                NavigationLink(
                                    destination: ComicDetailsView(comic: comic),
                                    label: {
                                        
                                        AsyncImage(url: URL(string: getImageURL(imgs: comic.imgs))!, placeholder: { Color.gray.opacity(0.15) }) { image in
                                            Image(uiImage: image)
                                                .resizable()
                                        }.aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: Screen.width / 2 - 20)
                                        .overlay(
                                            Text("\(comic.id)")
                                                .font(.footnote)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 3)
                                                .background(Color.gray.opacity(0.75))
                                                .clipShape(Capsule())
                                                .padding(5)
                                            
                                            , alignment: .topLeading
                                        )
                                        
                                        
                                    })
                            }
                        }
                        
                        
                    }
                    .padding(.top, 30)
                }
            }
            .navigationBarHidden(true)
            .padding(.top)
        }
    }
    
    func getImageURL(imgs: [ImageDetails]) -> String {
        var imageURL = ""
        
        for image in imgs {
            imageURL = image.sourceUrl
        }
        
        return imageURL
    }
    
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView()
    }
}
