//
//  SongTableViewCell.swift
//  iOS Albums
//
//  Created by Daniela Parra on 10/8/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate {
    func addSong(with title: String, duration: String)
}

class SongTableViewCell: UITableViewCell {

    func updateViews() {
        guard let song = song else { return }
        
        titleLabel.text = song.name
        durationLabel.text = song.duration
        addSongButton.isHidden = true
        
    }
    
    override func prepareForReuse() {
        
    }

    @IBAction func addSong(_ sender: Any) {
        guard let name = titleLabel.text,
            let duration = durationLabel.text else { return }
        
        delegate?.addSong(with: name, duration: duration)
    }
    
    var song: Song? {
        didSet {
            updateViews()
        }
    }
    var delegate: SongTableViewCellDelegate?
   
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var durationLabel: UITextField!
    @IBOutlet weak var addSongButton: UIButton!
    
}
