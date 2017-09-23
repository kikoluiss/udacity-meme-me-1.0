//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kiko Santos on 22/09/17.
//  Copyright © 2017 Kiko Santos. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme!
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memedImageView.image = meme.memedImage
    }
    
}
