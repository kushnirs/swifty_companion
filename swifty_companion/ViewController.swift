//
//  ViewController.swift
//  swifty_companion
//
//  Created by Sergee on 8/7/18.
//  Copyright © 2018 Sergee. All rights reserved.
//

import UIKit
import OAuthSwift

class ViewController: UIViewController {

    let oauthswift = OAuth2Swift(
        consumerKey: "88056ff98224f93d83630aff6da5e7d8c5a8967a1f326c445dcf790f9294a714",
        consumerSecret: "6ba9a01b314e6a14e6ab8f1160da21971e851781ffe8a75c778557c8db53ad86",
        authorizeUrl: "https://api.intra.42.fr/oauth/authorize",
        responseType: "token"
    )
    
    oauthswift.authorizeWithCallbackURL( NSURL(string: "oauth-swift://oauth-callback/intra.42"), scope: "likes+comments", state:"INSTAGRAM",
    success: {
        credential, response in
        println(credential.oauth_token)
    },
    failure: failureHandler)
    
    @IBOutlet weak var outlet: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func action(_ sender: Any)
    {
//        performSegue(withIdentifier: "segue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchButton.layer.cornerRadius = 5 // Set border radius (Make it curved, increase this for a more rounded button
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

