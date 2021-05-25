# XKCD
XKCD Comic Viewer

## App Breakdown
 * Architechture: MVVM
 * Persistance: CoreData
 * Coding style: SwiftLint

## Views
HomeView
 * Scrollable comics with description
 * Sort by latest, earliest
 * Share and favorite button

BrowseView
 * Browse scrollable comics
 * Comic detail view
 * Sort by latest, earliest
 * Search by title, number, transcript, alt

FavoriteView
 * Favorite comics saved from HomeView and BrowseView
 * Swipe to delete with Edit button

Others - UIKit
 * Asynchronous image loading
 * Share Sheet to share/save image
 * Safari View for comic explanation
 * Pinch to zoom
