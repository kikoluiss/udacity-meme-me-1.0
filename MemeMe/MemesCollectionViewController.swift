//
//  MemesCollectionViewController.swift
//  MemeMe
//
//  Created by Kiko Santos on 20/09/17.
//  Copyright © 2017 Kiko Santos. All rights reserved.
//

import UIKit

class MemesCollectionViewController: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    let reuseIdentifier = "memeCollectionCell"

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]!

    var selectedMeme: Meme!
    
    let space: CGFloat = 3.0
    var dimension: CGFloat!

    let memeTextAttributes: [NSAttributedStringKey: Any] = [
        NSAttributedStringKey.strokeColor: UIColor.black,
        NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 14)!,
        NSAttributedStringKey.strokeWidth: -2.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentEditViewController))

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = appDelegate.memes
        self.collectionView?.reloadData()
        
        updateLayout()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        updateLayout()
    }

    func updateLayout() {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            dimension = (view.frame.size.width - (4 * space)) / 5.0
        } else {
            dimension = (view.frame.size.width - (2 * space)) / 3.0
        }
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    @objc func presentEditViewController() {
        let memeEditViewController = storyboard?.instantiateViewController(withIdentifier: "memeEditViewController")
        present(memeEditViewController!, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemesCollectionViewCell
    
        cell.imageView.image = memes[indexPath.row].originalImage
        let topText = NSAttributedString(string: memes[indexPath.row].topText, attributes: memeTextAttributes)
        cell.topLabel.attributedText = topText
        let bottomText = NSAttributedString(string: memes[indexPath.row].bottomText, attributes: memeTextAttributes)
        cell.bottomLabel.attributedText = bottomText
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMeme = memes[indexPath.row]
        performSegue(withIdentifier: "collectionToDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let memeDetailViewController = segue.destination as! MemeDetailViewController
        memeDetailViewController.meme = selectedMeme
    }

}
