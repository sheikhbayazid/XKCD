//
//  Comic.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

//{
//  "month": "5",
//  "num": 2463,
//  "link": "",
//  "year": "2021",
//  "news": "",
//  "safe_title": "Astrophotography",
//  "transcript": "",
//  "alt": "[One hill over, a competing astrophotographer does a backflip over a commercial airliner while throwing a tray of plastic space stations into the air, through which a falcon swoops to 'grab' the real one.]",
//  "img": "https://imgs.xkcd.com/comics/astrophotography.png",
//  "title": "Astrophotography",
//  "day": "14"
//}

//{
//    "id": 1,
//    "publishedAt": "2006-01-01T00:00:00.000Z",
//    "news": "",
//    "safeTitle": "Barrel - Part 1",
//    "title": "Barrel - Part 1",
//    "transcript": "[[A boy sits in a barrel which is floating in an ocean.]]\nBoy: I wonder where I'll float next?\n[[The barrel drifts into the distance. Nothing else can be seen.]]\n{{Alt: Don't we all.}}",
//    "alt": "Don't we all.",
//    "sourceUrl": "https://xkcd.com/1",
//    "explainUrl": "https://www.explainxkcd.com/wiki/index.php/1",
//    "interactiveUrl": null,
//    "imgs": [
//      {
//        "height": 311,
//        "width": 577,
//        "ratio": 1.855305466237942,
//        "sourceUrl": "https://imgs.xkcd.com/comics/barrel_cropped_(1).jpg",
//        "size": "x1"
//      }
//    ]
//  }


import Foundation

struct ComicResponse: Identifiable, Decodable, Comparable {
    let id: Int
    let safeTitle: String
    let title: String
    let transcript: String
    let alt: String
    let sourceUrl: String
    let explainUrl: String
    let imgs: [ImageDetails]
    
    static func < (lhs: ComicResponse, rhs: ComicResponse) -> Bool {
        lhs.id < rhs.id
    }
    
    struct ImageDetails: Decodable, Hashable {
        let height: Int
        let width: Int
        let sourceUrl: String
    }
}


struct Comic: Decodable {
    let month: String
    let num: Int
    let year: String
    let safe_title: String
    let alt: String
    let img: String
    let title: String
    let day: String
    
    
    static var example: Comic {
        Comic(month: "", num: 0, year: "", safe_title: "", alt: "", img: "", title: "", day: "")
    }
    
    static var example2: Comic {
        Comic(month: "05", num: 123, year: "2021", safe_title: "Safe Title", alt: "Alt", img: "image url", title: "Title", day: "02")
    }
}


