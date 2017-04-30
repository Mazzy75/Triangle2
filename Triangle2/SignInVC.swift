//
//  ViewController.swift
//  Triangle2
//
//  Created by shmali on 4/2/17.
//  Copyright © 2017 shmali. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    
    
    @IBOutlet weak var pwdField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func facebookBtnTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        print("SHOM:button tapped")
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("SHOM: Unable to authenticate with Facebook - \(error)")
            }
            else if result?.isCancelled == true {
                print("SHOM: User cancelled Facebook authentication")
            }
            else {
                print("SHOM: User succesfully authenticated with Facebook")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            self.firebaseAuth(credential)
            }
            print("SHOM:code finished")
        }
    }
    
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("SHOM: Unable to authenticate with Firebase - \(error)")
            }
            else {
                print("SHOM: User succesfully authenticated with Firebase")
            }
        })
        
    }
    @IBAction func signinTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = pwdField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    print ("SHOM: Email user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: pwd, completion: { (user, error) in
                        if error != nil {
                        print("SHOM: User unable to authenticate with firebase using email")
                        }
                        else {
                            print ("SHOM: Successfully authenticated with firebase")
                        }
                    })
                }
            })
        }
    }
}

