//
//  CustomNavigationBar.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 28/8/21.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Binding var sort: Sort
    
    var body: some View {
        VStack {
            HStack {
                Text("XKCD Comics")
                    .font(.custom("xkcd", size: 26))
                
                Spacer()
                sortMenu(sort: $sort)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(sort: .constant(.latest))
            .padding()
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
