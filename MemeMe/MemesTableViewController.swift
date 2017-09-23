//
//  MemesTableViewController.swift
//  MemeMe
//
//  Created by Kiko Santos on 20/09/17.
//  Copyright © 2017 Kiko Santos. All rights reserved.
//

import UIKit

class MemesTableViewController: UITableViewController {

    let reuseIdentifier = "memeTableCell"

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var memes: [Meme]!
    
    var selectedMeme: Meme!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentEditViewController))
    }

    @objc func presentEditViewController() {
        let memeEditViewController = storyboard?.instantiateViewController(withIdentifier: "memeEditViewController")
        present(memeEditViewController!, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = appDelegate.memes
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.imageView?.image = memes[indexPath.row].originalImage
        cell.textLabel?.text = memes[indexPath.row].topText
        cell.detailTextLabel?.text = memes[indexPath.row].bottomText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeme = memes[indexPath.row]
        performSegue(withIdentifier: "tableToDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let memeDetailViewController = segue.destination as! MemeDetailViewController
        memeDetailViewController.meme = selectedMeme
    }
}
