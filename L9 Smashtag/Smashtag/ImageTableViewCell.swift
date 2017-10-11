//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/10/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgMention: UIImageView!
    
    var imgURL: URL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = imgURL {
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imageData = urlContents, url == self?.imgURL {
                    DispatchQueue.main.async {
                        self?.imgMention?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    

}
