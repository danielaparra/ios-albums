//
//  Album.swift
//  iOS Albums
//
//  Created by Daniela Parra on 10/8/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
    
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
        
//        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        
//        let coverArtSubContainer = try coverArtContainer.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self)
        
        let coverArtContainer = try container.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self, forKey: .coverArt)

        
        let coverArtString = try coverArtContainer.decode(String.self, forKey: .url)
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
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(artist, forKey: .artist)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(songs, forKey: .songs)
        
        let substrings = genres.split(separator: ",")
        let genreStrings = substrings.compactMap { (substring) -> String in
            let newSubstring = substring.trimmingCharacters(in: CharacterSet.whitespaces)
            return String(newSubstring)
        }
        try container.encode(genreStrings, forKey: .genres)
        
        var coverArtContainer = container.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self, forKey: .coverArt)
        try coverArtContainer.encode(coverArt.absoluteString, forKey: .url)
        
    }
    
    init(artist: String, coverArt: URL, genres: String, id: String = UUID().uuidString, name: String, songs: [Song] = []) {
        
        self.artist = artist
        self.coverArt = coverArt
        self.genres = genres
        self.id = id
        self.name = name
        self.songs = songs
    }
    
    let artist: String
    let coverArt: URL
    let genres: String
    let id: String
    let name: String
    var songs: [Song]
}
