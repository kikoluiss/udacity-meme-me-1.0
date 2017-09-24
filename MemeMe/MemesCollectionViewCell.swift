//
//  MemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Kiko Santos on 20/09/17.
//  Copyright © 2017 Kiko Santos. All rights reserved.
//

import UIKit

class MemesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!

    let memeTextAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.strokeColor: UIColor.black,
        NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 14)!,
        NSAttributedStringKey.strokeWidth: -2.0
    ]

    func setupCellWith(meme:Meme) {
        imageView.contentMode = .scaleAspectFill
        imageView.image = meme.originalImage
        let topText = NSAttributedString(string: meme.topText, attributes: memeTextAttributes)
        topLabel.attributedText = topText
        let bottomText = NSAttributedString(string: meme.bottomText, attributes: memeTextAttributes)
        bottomLabel.attributedText = bottomText
    }
    
}
