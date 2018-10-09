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

}
