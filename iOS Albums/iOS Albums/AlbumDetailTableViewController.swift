//
//  AlbumDetailTableViewController.swift
//  iOS Albums
//
//  Created by Daniela Parra on 10/8/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
    
    func addSong(with title: String, duration: String) {
        let song = Song(name: title, duration: duration)
        tempSongs.append(song)
        tableView.reloadData()
        
        let indexPath = IndexPath(row: tempSongs.count, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    func updateViews() {
        
        guard let album = album else {
            title = "New Album"
            return
        }
        
        title = album.name
        
        nameLabel.text = album.name
        artistLabel.text = album.artist
        genresLabel.text = album.genres
        urlLabel.text = album.coverArt.absoluteString
        tempSongs = album.songs
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tempSongs.count + 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Song Cell", for: indexPath) as? SongTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        cell.song = tempSongs[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tempSongs.count {
            return CGFloat(140)
        } else {
            return CGFloat(100)
        }
    }

    @IBAction func saveAlbum(_ sender: Any) {
        let name = nameLabel.text ?? ""
        let artist = artistLabel.text ?? ""
        let genres = genresLabel.text ?? ""
        let coverArt = urlLabel.text ?? ""
        
        if let album = album {
            albumController?.update(album: album, name: name, artist: artist, genres: genres, coverArt: URL(string: coverArt)!, songs: tempSongs)
        } else {
            albumController?.createAlbum(name: name, artist: artist, genres: genres, coverArt: URL(string: coverArt)!, songs: tempSongs)
        }
        navigationController?.popViewController(animated: true)
    }
    
    var album: Album? {
        didSet {
            if isViewLoaded {
                updateViews()
            }
        }
    }
    var albumController: AlbumController?
    var tempSongs: [Song] = []
    
    @IBOutlet weak var urlLabel: UITextField!
    @IBOutlet weak var genresLabel: UITextField!
    @IBOutlet weak var artistLabel: UITextField!
    @IBOutlet weak var nameLabel: UITextField!
    
}
