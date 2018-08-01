//
//  ViewController.swift
//  MemeMe
//
//  Created by Kiko Santos on 20/09/17.
//  Copyright © 2017 Kiko Santos. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cancelNavBarButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var memeImageView: UIImageView!

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let memeTextAttributes: [String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        setStyle(toTextField: topTextField)
        setStyle(toTextField: bottomTextField)

        self.resetView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func cancelEdition(_ sender: Any) {
        self.resetView()
    }
    
    @IBAction func shareMemedImage(_ sender: Any) {
        if let imageToMeme = memeImageView.image {

            let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageToMeme, memedImage: generateMemedImage())
            
            let shareViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
            shareViewController.completionWithItemsHandler = {
                (s, ok, items, error) in
                if ok {
                    self.save(meme)
                }
                else {
                    if let errorMessage = error?.localizedDescription {
                        self.presentAlertController(title: "Sharing Meme Error", message: errorMessage)
                    }
                }
            }
            self.present(shareViewController, animated: true, completion: nil)
        }
        else {
            self.presentAlertController(title: "Sharing Meme Error", message: "An image has to be picked before sharing it!")
        }
    }

    func setStyle(toTextField textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }
    
    func resetView() {
        topTextField.text = nil
        bottomTextField.text = nil
        memeImageView.image = nil
    }
    
    func presentAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMemedImage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerController(sourceType: .camera)
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentPickerController(sourceType: .photoLibrary)
    }
    
    func presentPickerController(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.memeImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification) - bottomTextField.frame.height
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {
        self.navigationController?.navigationBar.isHidden = true
        showToolBars(true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.isHidden = false
        showToolBars(false)
        
        return memedImage
    }
    
    func showToolBars(_ show:Bool) {
        self.toolBar.isHidden = show
    }
    
    func save(_ meme: Meme) {
        appDelegate.memes.append(meme)
        self.dismiss(animated: true, completion: nil)
    }
    
}

