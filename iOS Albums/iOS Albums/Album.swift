//
//  Album.swift
//  iOS Albums
//
//  Created by Daniela Parra on 10/8/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct Album: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case artist
        case coverArt
        case genres
        case id
        case name
        case songs
        
        enum CoverArtCodingKeys: String, CodingKey {
            case url
        }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let artist = try container.decode(String.self, forKey: .artist)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        
        let coverArtSubContainer = try coverArtContainer.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self)
        
        let coverArtString = try coverArtSubContainer.decode(String.self, forKey: .url)
        let coverArt = URL(string: coverArtString)!
        
        var genreContainer = try container.nestedUnkeyedContainer(forKey: .genres)
        
        var genreStrings: [String] = []
        
        while !genreContainer.isAtEnd {
            let genreString = try genreContainer.decode(String.self)
            genreStrings.append(genreString)
        }
        
        let genres = genreStrings.joined(separator: ", ")
        
        let songs = try container.decode([Song].self, forKey: .songs)
        
        self.artist = artist
        self.id = id
        self.name = name
        self.coverArt = coverArt
        self.genres = genres
        self.songs = songs
    }
    
    let artist: String
    let coverArt: URL
    let genres: String
    let id: String
    let name: String
    let songs: [Song]
}
