//
//  ViewController.swift
//  MemeMeApp 1.0
//
//  Created by Timur Krüger on 19.03.20.
//  Copyright © 2020 Yumeda. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - MemePicture Attributes Struct
    struct Meme {
        var topTextfield: String
        var bottomTextfield: String
        var image: UIImage
        var memedImage: UIImage
    }
    
    // MARK: - MemeText Attributes Struct
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.backgroundColor: UIColor.clear,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    // MARK: - Outlets
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    
    // MARK: - App Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [space, cameraButton, space, libraryButton, space]
        
        shareButton.isEnabled = false
        resetButton.isEnabled = false
        
        topTextfield.text = "TOP QUOTE"
        topTextfield.defaultTextAttributes = memeTextAttributes
        topTextfield.textAlignment = .center
        topTextfield.borderStyle = .none
        topTextfield.delegate = self
        
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.text = "BOTTOM QUOTE"
        bottomTextfield.textAlignment = .center
        bottomTextfield.borderStyle = .none
        bottomTextfield.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        subscribeToKeyboardNotificationsShow()
        subscribeToKeyboardNotificationsHide()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        unsubscribeFromKeyboardNotificationsShow()
        unsubscribeFromKeyboardNotificationsHide()
    }
    
    // MARK: - Camera and Library functions
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .camera
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromLibrary(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Closing function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imagePickerView.image = image
            
            shareButton.isEnabled = true
            resetButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Text Field Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = ""
        }
        resetButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    // MARK: - Keyboard Notifications
    @objc func keyboardWillShow(_ notification: Notification) {
        if (bottomTextfield.isEditing && view.frame.origin.y == 0) {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if(bottomTextfield.isEditing && view.frame.origin.y != 0) {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificationsHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func subscribeToKeyboardNotificationsShow() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificationsShow() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Activity View Controller
    @IBAction func shareMeme(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Saving Meme
        activityViewController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed {
                self.save(memedImage: memedImage)
            }
        }
        shareButton.isEnabled = false
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func resetMeme(_ sender: Any){
        imagePickerView.image = UIImage(named: "default")
        
        topTextfield.text = "TOP QUOTE"
        bottomTextfield.text = "BOTTOM QUOTE"
        
        resetButton.isEnabled = false
    }
    
    // MARK: - Generating and Saving Meme
    func generateMemedImage() -> UIImage {
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    func save(memedImage: UIImage) {
        let meme = Meme(topTextfield: topTextfield.text!, bottomTextfield: bottomTextfield.text!, image: imagePickerView.image!, memedImage: memedImage)
    }
}
