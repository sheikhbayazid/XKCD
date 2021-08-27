//
//  CustomNavigationBar.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 28/8/21.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Binding var sort: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("XKCD Comics")
                    .font(.custom("xkcd", size: 26))
                
                Spacer()
                
                Menu {
                    Picker(selection: $sort, label: Text("Filter options")) {
                        Text("Latest").tag(0)
                        Text("Earliest").tag(1)
                    }
                }
                
                label: {
                    Image(systemName: "line.horizontal.3.decrease.circle")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            Divider()
        }
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(sort: .constant(1))
    }
}
