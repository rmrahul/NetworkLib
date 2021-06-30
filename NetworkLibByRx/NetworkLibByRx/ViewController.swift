//
//  ViewController.swift
//  NetworkLibByRx
//
//  Created by Rahul Mane on 19/02/18.
//  Copyright © 2018 developer. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var user = SMUser()
        user.confirm_password = "Rahul@123"
        user.device_token = "device_Token"
        user.device_type = "device-type"
        user.email = "rahul@gmail.com"
        user.first_name = "Rahul"
        user.gender = "male"
        user.last_name = "Mane"
        
        let provider = MoyaProvider<UserEndpoints>()

        UserManager().register(user: user).subscribe { (response) in
            print("Response ---",response)
            
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

