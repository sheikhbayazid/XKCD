//
//  ShareSheetView.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/19/21.
//

import SwiftUI

// MARK: - Full-Screen Share Sheet
struct ShareSheetView: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) { }
}

struct ShareSheetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetView(items: [])
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}

// MARK: - Half-Screen Share Sheet
func shareSheet(for items: [Any]) {
    let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
    
    UIApplication.shared.windows.first?.rootViewController?.present(activityController, animated: true, completion: nil)
}
