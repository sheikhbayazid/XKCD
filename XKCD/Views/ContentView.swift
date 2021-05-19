//
//  ContentView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import SwiftUI
import SafariServices

//browse through the comics,
//see the comic details, including its description,
//search for comics by the comic number as well as text,
//get the comic explanation
//favorite the comics, which would be available offline too,
//send comics to others,
//get notifications when a new comic is published,
//support multiple form factors.


struct ContentView: View {
    @ObservedObject var viewModel = ComicViewModel()
    //    @State private var comic = Comic.example
    //
    var body: some View {
        TabView {
            TabViewComics()
                .tabItem {
                    Image(systemName: "rectangle.3.offgrid.bubble.left")
                    Text("Comics")
                }
            
            BrowseView()
                .tabItem {
                    Image(systemName: "rectangle.and.text.magnifyingglass")
                    Text("Browse")
                }
            
            Text("Favorite Comics")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }.accentColor(.primary)
        .preferredColorScheme(.dark)
        
        
    }
    
}

struct TabViewComics: View {
    @ObservedObject var viewModel = ComicViewModel()
    
    var body: some View {
        VStack {
            TabView {
                //MARK: - Add Sorting Option - Latest / Earliest
                
                // Earliest
                //                ForEach(1...viewModel.totalComics, id: \.self) { number in
                //                    ComicTabView(comicNumber: number)
                //                }
                
                // Latest
                ForEach(Array(stride(from: viewModel.totalComics, to: 1, by: -1)), id: \.self) { number in
                    ComicTabView(comicNumber: number)
                }
                
                //MARK: - Add Reverse, Random Comic Option
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
    }
}

//#warning("Add share sheet to share/save image")

struct BrowseView: View {
    @ObservedObject var viewModel = ComicViewModel()
    let columns = Array(repeating: GridItem(.flexible()), count: 2)
    let screen = UIScreen.main.bounds.size
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 5) {
                    TextField("Search Comic by text, number", text: $viewModel.searchText)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    LazyVGrid(columns: columns) {
                        ForEach(viewModel.comicResponse.sorted().reversed().filter({ viewModel.searchText.isEmpty ? true : $0.title.lowercased().contains(viewModel.searchText.lowercased()) || String($0.id).contains((viewModel.searchText)) || String($0.alt).contains((viewModel.searchText)) })) { comic in
                            
                            
                            NavigationLink(
                                destination: ComicView(comic: comic),
                                label: {
                                    
                                    //VStack(alignment: .leading) {
                                    Image(uiImage: getImageURL(imgs: comic.imgs).load())
                                        .resizable()
                                        .scaledToFit()
                                        .animation(.spring())
                                        .frame(maxWidth: screen.width / 2 - 20)
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
                                    
                                    
                                    //                                        Text("\(comic.id). " + comic.title)
                                    //
                                    //                                        Text(comic.alt)
                                    //                                            .lineLimit(2)
                                    //                                            .foregroundColor(.secondary)
                                    //                                    }.padding(.horizontal)
                                    //                                    .padding(.vertical, 5)
                                    
                                })
                        }
                    }.padding(.top, 30)
                }
            }.navigationBarHidden(true)
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



struct ComicView: View {
    let comic: ComicResponse
    var imageURL = ""
    @State private var isSheetShowing = false
    
    let screen = UIScreen.main.bounds.size
    
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
            Image(uiImage: imageURL.load())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .animation(.default)
                .frame(maxWidth: screen.width, maxHeight: screen.height * 0.75)
                .pinchToZoom()
            
            Text(comic.alt)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            
            Button(action: {
                self.isSheetShowing = true
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("See")
                    Text("explanation")
                        .underline()
                        .foregroundColor(.blue)
                }
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
        .navigationBarItems(trailing:
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


struct SingleComicView: View {
    let comic: Comic
    let screen = UIScreen.main.bounds.size
    @State private var isFavorite = false
    @State private var isShareSheetShowing = false
    @State private var items: [Any] = []
    @State private var isTapped = false
    
    var body: some View {
        VStack(spacing: 10) {
            VStack {
                HStack {
                    Button(action: {
                        self.isShareSheetShowing = true
                        
                        items.removeAll()
                        items.append(comic.img.load())
                        
                        
                    }, label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }).sheet(isPresented: $isShareSheetShowing) {
                        ShareSheetView(items: items )
                    }
                    
                    Spacer()
                    
                    if comic.num != 0 {
                        Text("\(comic.num). " + comic.title)
                            .fontWeight(.medium)
                            .font(.title3)
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
                }.padding(.top)
                
                Divider()
            }.opacity(isTapped ? 1 : 0)
            
            Spacer()
            
            
            if !comic.img.isEmpty {
                Image(uiImage: comic.img.load())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(5)
                    .frame(maxWidth: screen.width, maxHeight: screen.height * 0.6)
                    .pinchToZoom()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.005)) {
                            self.isTapped.toggle()
                        }
                    }
                
                Text(comic.alt)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.bottom, 40)
            }
            
        }.padding(.horizontal)
        //        .onDisappear {
        //            withAnimation(.easeInOut(duration: 0.005)) {
        //                self.isTapped.toggle()
        //            }
        //        }
    }
}


struct ComicTabView: View {
    let comicNumber: Int
    
    @State private var comic = Comic.example
    
    var body: some View {
        VStack {
            SingleComicView(comic: comic)
                .onAppear (perform: loadComic)
        }
    }
    
    
    func loadComic() {
        fetchData(for: comicNumber)
    }
    
    
    func fetchData(for number: Int) {
        guard let url = URL(string: "https://xkcd.com/\(number)/info.0.json") else {
            print("Invalid URL")
            return
        }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error == nil {
                let decoder = JSONDecoder()
                
                if let data = data {
                    do {
                        let decodedData = try decoder.decode(Comic.self, from: data)
                        DispatchQueue.main.async {
                            print(decodedData)
                            self.comic = decodedData
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
}
