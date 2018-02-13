//
//  RegisterViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/11/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var registrationStatus: UILabel!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        createAccountButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccountButton(_ sender: UIButton) {
        if passwordTextField.text != confirmPasswordTextField.text {
            self.registrationStatus.text = "Passwords Do Not Match"
            self.registrationStatus.textColor = UIColor.red
        }
        
        else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                //Check if user account created successfully
                if user != nil {
                    self.registrationStatus.text = "Success!"
                    self.registrationStatus.textColor = UIColor.green
                    
                    name = self.nameTextField.text!
                    let user = Auth.auth().currentUser
                    if let user = user {
                        userID = user.uid
                        email = user.email!
                        // ...
                    }
                    
                    let usersReference = self.ref?.child("users").child(userID)
                    let values = ["name": name, "email": email, "studentName": kidName, "address": addressFull, "accountBalance": accountBalance]
                    usersReference?.updateChildValues(values)
                    
                    self.performSegue(withIdentifier: "register", sender: self)
                }
                else {
                    self.registrationStatus.text = "Account Creation Failed"
                    self.registrationStatus.textColor = UIColor.red
                }
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
