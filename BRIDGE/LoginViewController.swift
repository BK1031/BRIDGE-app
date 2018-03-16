//
//  LoginViewController.swift
//  BRIDGE
//
//  Created by Bharat Kathi on 1/10/18.
//  Copyright © 2018 Bharat Kathi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var logInStatusLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    
    var ref:DatabaseReference?
    var databaseHandle:DatabaseHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        loginButton.layer.cornerRadius = 10
        createAccountButton.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        self.logInStatusLabel.text = ""
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            //Check if User exists
            if user != nil {
                self.logInStatusLabel.text = "Logging In"
                self.logInStatusLabel.textColor = UIColor.green
                
                let user = Auth.auth().currentUser
                if let user = user {
                    userID = user.uid
                    email = user.email!
                    // ...
                }
                Database.database().reference().child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject] {
                        name = dictionary["name"] as! String
                        kidName = dictionary["studentName"] as! String
                        addressFull = dictionary["address"] as! String
                        phone = dictionary["phone"] as! String
                        driverStatus = dictionary["driverStatus"] as! Bool
                    }
                    
                }, withCancel: nil)
                
                self.performSegue(withIdentifier: "login", sender: self)
            }
            else {
                self.logInStatusLabel.text = "Login Failed"
                self.logInStatusLabel.textColor = UIColor.red
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
