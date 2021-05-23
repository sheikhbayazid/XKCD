//
//  String+Extension.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/19/21.
//

import SwiftUI

extension String {
    // MARK: - Convert URL String to UIImage
    func loadUIImage() -> UIImage {
        do {
            guard let url = URL(string: self) else { return UIImage()}
            
            let data = try Data(contentsOf: url)
            
            return UIImage(data: data) ?? UIImage()
        } catch {
            
        }
        
        return UIImage()
    }
    
    // MARK: - Load Image data to Save to CoreData
    func loadImageData() -> Data? {
        do {
            guard let url = URL(string: self) else { return Data()}
            
            let data = try Data(contentsOf: url)
            
            return data
        } catch {
            
        }
        
        return Data()
    }
}

// MARK: - Screen Sizes
struct Screen {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
}




extension ScrollView {
    
    public func fixFlickering() -> some View {
        
        return self.fixFlickering { (scrollView) in
            
            return scrollView
        }
    }
    
    public func fixFlickering<T: View>(@ViewBuilder configurator: @escaping (ScrollView<AnyView>) -> T) -> some View {
        
        GeometryReader { geometryWithSafeArea in
            GeometryReader { geometry in
                configurator(
                ScrollView<AnyView>(self.axes, showsIndicators: self.showsIndicators) {
                    AnyView(
                    VStack {
                        self.content
                    }
                    .padding(.top, geometryWithSafeArea.safeAreaInsets.top)
                    .padding(.bottom, geometryWithSafeArea.safeAreaInsets.bottom)
                    .padding(.leading, geometryWithSafeArea.safeAreaInsets.leading)
                    .padding(.trailing, geometryWithSafeArea.safeAreaInsets.trailing)
                    )
                }
                )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
