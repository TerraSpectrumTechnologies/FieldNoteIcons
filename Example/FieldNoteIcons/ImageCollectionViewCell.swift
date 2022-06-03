//
//  ImageCollectionViewCell.swift
//  FieldNoteIcons_Example
//
//  Created by Matt Hollen on 1/26/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageNameLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        imageView.image = nil
        imageNameLabel.text = ""
    }
}
