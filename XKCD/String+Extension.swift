//
//  String+Extension.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/19/21.
//

import SwiftUI

extension String {
    func load() -> UIImage {
        do {
            guard let url = URL(string: self) else { return UIImage()}
            
            let data = try Data(contentsOf: url)
            
            return UIImage(data: data) ?? UIImage()
        } catch {
            
        }
        
        return UIImage()
    }
}
