//
//  EditAccountViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/13/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var studentTextField: UITextField!
    
    @IBOutlet weak var addressLine1TextField: UITextField!
    
    @IBOutlet weak var addressCityTextField: UITextField!
    
    @IBOutlet weak var addressStateTextField: UITextField!
    
    @IBOutlet weak var addressZIPTextField: UITextField!
    
    @IBOutlet weak var profileButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        profileButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "backHome", sender: self)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profilePic = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfileButton(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        controller.allowsEditing = true
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        //Check if any changes were made
        if studentTextField.text != "" {
            kidName = studentTextField.text!
        }
        if addressLine1TextField.text != "" {
            addressLine1 = addressLine1TextField.text!
            addressFull = addressLine1 + ", " + addressCity + ", " + addressState + " " + addressZIP
        }
        if addressCityTextField.text != "" {
            addressCity = addressCityTextField.text!
            addressFull = addressLine1 + ", " + addressCity + ", " + addressState + " " + addressZIP
        }
        if addressStateTextField.text != "" {
            addressState = addressStateTextField.text!
            addressFull = addressLine1 + ", " + addressCity + ", " + addressState + " " + addressZIP
        }
        if addressZIPTextField.text != "" {
            addressZIP = addressZIPTextField.text!
            addressFull = addressLine1 + ", " + addressCity + ", " + addressState + " " + addressZIP
        }
        
        let data = ["studentName": kidName, "address": addressFull]
        self.ref?.child("users").child(userID).updateChildValues(data)
        
        self.performSegue(withIdentifier: "backHome", sender: self)
    }
    
}
