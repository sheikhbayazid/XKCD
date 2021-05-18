//
//  ContentView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import SwiftUI
import SafariServices

struct ContentView: View {
    //    @ObservedObject var viewModel = ComicViewModel()
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
                    Image(systemName: "rectangle.3.offgrid.fill")
                    Text("Browse")
                }
            
            Text("Favorite Comics")
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
        }.accentColor(.primary)
        
        
    }
    
}

struct TabViewComics: View {
    @ObservedObject var viewModel = ComicViewModel()
    
    var body: some View {
        VStack {
            TabView {
                ForEach(1...viewModel.totalComics, id: \.self) { number in
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
    }
}

#warning("Add share sheet to share/save image")

struct BrowseView: View {
    @ObservedObject var viewModel = ComicViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                
                VStack(spacing: 5) {
                    TextField("Search Comic by name, number", text: $viewModel.searchText)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal)
                    
                    Spacer()
                    
                    LazyVStack {
                        ForEach(viewModel.comicResponse.sorted().reversed().filter({ viewModel.searchText.isEmpty ? true : $0.title.lowercased().contains(viewModel.searchText.lowercased()) || String($0.id).contains((viewModel.searchText)) })) { comic in
                            
                            NavigationLink(comic.title, destination: ComicView(comic: comic))
                        }
                    }.padding(.top, 30)
                }
            }.navigationBarHidden(true)
            .padding(.top)
        }
    }
}





struct ComicView: View {
    let comic: ComicResponse
    var imageURL = ""
    @State private var scale: CGFloat = 1
    @State private var offset: CGSize = .zero
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
        let dragGesture = DragGesture()
            .onChanged { value in self.offset = value.translation }
            .onEnded { _ in
                withAnimation {
                    self.offset = .zero
                }
            }
        
        let magnificationGesture = MagnificationGesture()
            .onChanged { value in
                withAnimation(.spring()) {
                    self.scale = value
                }
            }
            
            .onEnded { _ in
                withAnimation(.spring()) {
                    self.scale = 1
                }
            }
        
        let combined = magnificationGesture.sequenced(before: dragGesture)
        
        
        return VStack {
            Image(uiImage: imageURL.load())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(5)
                .frame(maxWidth: screen.width, maxHeight: screen.height * 0.75)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(combined)
            
            Button(action: {
                self.isSheetShowing = true
            }, label: {
                HStack {
                    Spacer()
                    
                    Text("See")
                    Text("explanation")
                        .underline()
                        .foregroundColor(.blue)
                }.padding()
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
                                        ShareSheet(items: items )
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
    
    var body: some View {
        VStack(spacing: 10) {
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
                    ShareSheet(items: items )
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
            
            Spacer()
            
            
            if comic.num != 0 {
                HStack {
                    Text("\(comic.num).")
                        .fontWeight(.medium)
                    
                    Text(comic.title)
                        .fontWeight(.medium)
                    
                }.font(.title3)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(10)
            }
            
            
            //Spacer()
            
            if !comic.img.isEmpty {
                Image(uiImage: comic.img.load())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(5)
                    .frame(maxWidth: screen.width, maxHeight: screen.height * 0.6)
                
                Text(comic.alt)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
            }
            
        }.padding(.horizontal)
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



struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        
    }
    
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
    
    
}
