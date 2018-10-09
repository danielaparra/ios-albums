//
//  AlbumController.swift
//  iOS Albums
//
//  Created by Daniela Parra on 10/8/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class AlbumController {
    
    func testDecodingExampleAlbum() -> Album? {
        
        guard let url = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            NSLog("JSON file doesn't exist.")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            let album = try JSONDecoder().decode(Album.self, from: data)
            print("success!")
            return album
        } catch {
            NSLog("Error decoding data: \(error)")
            return nil
        }
        
    }
    
    func testEncodingExampleAlbum() {
        guard let album = testDecodingExampleAlbum() else {
            NSLog("Error")
            return
        }
        
        do {
            _ = try JSONEncoder().encode(album)
            print("Success encoding!")
        } catch {
            NSLog("Error encoding album:\(error)")
        }
    }
    
    func createAlbum(name: String, artist: String, genres: String, coverArt: URL, songs: [Song]) {
        
        let album = Album(artist: artist, coverArt: coverArt, genres: genres, name: name, songs: songs)
        albums.append(album)
        
        put(album: album) { (_) in
            
        }
    }
    
    func update(album: Album, name: String, artist: String, genres: String, coverArt: URL, songs: [Song]) {
        
        let tempAlbum = Album(artist: artist, coverArt: coverArt, genres: genres, id: album.id, name: name, songs: songs)
        
        guard let index = albums.index(of: album) else { return }
        
        albums.remove(at: index)
        albums.insert(tempAlbum, at: index)
        
        put(album: tempAlbum) { (_) in
            
        }
    }
    
    func createSong(name: String, duration: String) -> Song {
        
        let song = Song(name: name, duration: duration)
        return song
    }
    
    func getAlbums(completion: @escaping (Error?) -> Void) {
        
        let requestURL = baseURL.appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching albums: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data found.")
                completion(NSError())
                return
            }
            
            if let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            
            do {
                let albumsResults = try JSONDecoder().decode([String: Album].self, from: data)
                
                self.albums = Array(albumsResults.values)
                completion(nil)
            } catch {
                NSLog("Error decoding data: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func put(album: Album, completion: @escaping (Error?) -> Void) {
        
        let id = album.id
        
        let requestURL = baseURL.appendingPathComponent(id).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(album)
        } catch {
            NSLog("Error encoding album: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing album")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data found.")
                completion(NSError())
                return
            }
            completion(nil)
            
        }.resume()
    }
    
    var albums: [Album] = []
    let baseURL = URL(string: "https://albums-3968e.firebaseio.com/")!
}
