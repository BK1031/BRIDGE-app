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
import CoreLocation

class EditAccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var studentTextField: UITextField!
    
    @IBOutlet weak var addressLine1TextField: UITextField!
    
    @IBOutlet weak var addressCityTextField: UITextField!
    
    @IBOutlet weak var addressStateTextField: UITextField!
    
    @IBOutlet weak var addressZIPTextField: UITextField!
    
    @IBOutlet weak var profileButton: UIButton!
    
    @IBOutlet weak var saveChangesButton: UIButton!
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        profileButton.layer.cornerRadius = 10
        saveChangesButton.layer.cornerRadius = 10
        self.navigationItem.title = "Edit Account"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(addressFull) { (placemarks, error) in
            if (error) != nil {
                print("Geocode ERROR!!!")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                homeLat = coordinates.latitude
                homeLong = coordinates.longitude
            }
        }
        
        let data = ["studentName": kidName, "address": addressFull, "homeLat": homeLat, "homeLong": homeLong] as [String : Any]
        self.ref?.child("users").child(userID).updateChildValues(data)
        
        dismiss(animated: true, completion: nil)
    }
    
}
