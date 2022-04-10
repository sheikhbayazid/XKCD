//
//  Comic.swift
//  XKCD
//
//  Created by Sheikh Bayazid on 5/17/21.
//

import Foundation

// MARK: - All Comics - https://api.xkcdy.com/comics - This API returns a all the comics available in xkcd
// NOTE: This api often returns error, if there's any decoding error then this server failed
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
    
    static let example = ComicResponse(id: 1,
                                       safeTitle: "safeTitle",
                                       title: "title",
                                       transcript: "transcript",
                                       alt: "In Dimensional Chess, every move is annotated",
                                       sourceUrl: "sourceUrl",
                                       explainUrl: "explainUrl",
                                       imgs: [ImageDetails(height: 250,
                                                           width: 250,
                                                           sourceUrl: "www.apple.com")]
    )
}

struct ImageDetails: Decodable, Hashable {
    let height: Int
    let width: Int
    let sourceUrl: String
}

// MARK: - Single Comic - "https://xkcd.com/info.0.json" - This API returns a single comic
struct Comic: Decodable {
    let month: String
    let num: Int
    let year: String
    let safe_title: String
    let alt: String
    let transcript: String
    let img: String
    let title: String
    let day: String
    
    static var example: Comic {
        Comic(month: "",
              num: 0,
              year: "",
              safe_title: "",
              alt: "",
              transcript: "",
              img: "",
              title: "",
              day: "")
    }
}
