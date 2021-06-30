//
//  ViewController.swift
//  NetworkLibByNative
//
//  Created by Rahul Mane on 20/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnSignUpclicked(_ sender: Any) {
        var user = SMUser()
        user.password = "Rahul123"
        user.confirm_password = "Rahul123"
        user.device_token = "device_Token"
        user.device_type = "device-type"
        user.email = "rahul@gmail.com"
        user.first_name = "Rahul"
        user.gender = "male"
        user.last_name = "Mane"
        
        UserManager.shared().performSignUp(loginRequestDTO: user) { (result) in
            switch result{
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func btnSigninClicked(_ sender: Any) {
        var login = SMLoginRequestDTO()
        login.email = "rahul@gmail.com"
        login.password = "Rahul123"
        login.device_token = "121212"
        login.device_type = "IOS"
        
        UserManager.shared().performLogin(loginRequestDTO: login, completion: { (result) in
            switch result{
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        })
    }
        
}

