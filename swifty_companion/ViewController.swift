//
//  ViewController.swift
//  swifty_companion
//
//  Created by Sergee on 8/7/18.
//  Copyright © 2018 Sergee. All rights reserved.
//

import UIKit
import OAuthSwift

class Info {
    var userIMG: String?
    var displayname: String?
    var email: String?
    var login: String?
    var number: String?
    var wallet: String?
    var corrections: String?
    var grade: String?
    var coalition: Int?
    var level: String?
    var location: String?
    
    init(json_user: NSDictionary)
    {
        if let displayname = (json_user["displayname"] as? String) {
            self.displayname = displayname
        }
        if let email = json_user["email"] as? String {
            self.email = email
        }
        if let login = json_user["login"] as? String {
            self.login = login
        }
        if let number = json_user["phone"] as? String {
            self.number = number
        }
        if let wall = json_user["wallet"] {
            self.wallet = "Wallet: \(wall)"
        }
        if let point = json_user["correction_point"] {
            self.corrections = "Correction points: \(point)"
        }
        if let urkKey = json_user["image_url"] as? String {
            self.userIMG = urkKey
        }
        if let cursus = json_user["cursus_users"] as? [NSDictionary] {
            
            if let grade = cursus[0]["grade"] as? String {
                self.grade = "Grade: " + grade
            }
            if let level = cursus[0]["level"] {
                self.level = level as? String
            }
            
        }
        if let location = json_user["location"] {
            self.location = location as? String
        }
//        if let coalition = json_coal["coalition"] as? Int {
//            self.coalition = coalition
//        }
    
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var outlet: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func action(_ sender: Any)
    {
        if self.outlet.text != "" {
            errorLabel.isHidden = true
        }
        
        self.getRequest(login: outlet.text!,
                        oauthswift: oauthswift,
                        param: token,
                        completionHandler: {
                            self.performSegue(withIdentifier: "segue", sender: self) })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let secondController = segue.destination as! SecondViewController
        secondController.student = self.student
    }
    
    let oauthswift = OAuth1Swift(consumerKey: "", consumerSecret: "")
    var token = Dictionary<String,Any>()
    var student: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // FirstResponder for outletTextField
        outlet.becomeFirstResponder()
        
        // Set border radius (Make it curved, increase this for a more rounded button
        searchButton.layer.cornerRadius = 5
        
        // Add errorLabel content
        errorLabel.text = "⚠️ wrong login"
        
        // Set parameter for access_token
        let Parameters = [
            "grant_type" : "client_credentials",
            "client_id" : "88056ff98224f93d83630aff6da5e7d8c5a8967a1f326c445dcf790f9294a714",
            "client_secret" : "6ba9a01b314e6a14e6ab8f1160da21971e851781ffe8a75c778557c8db53ad86"
        ]
        
        //Call PostRequest func
        postRequest(parameter: Parameters)
    }

    func postRequest(parameter: [String: String])
    {
        let _ = self.oauthswift.client.post("https://api.intra.42.fr/oauth/token", parameters: parameter,
                                            success: { response in
                                                print(response.string!)
                                                if let token = (try?  response.jsonObject() as! Dictionary<String,Any>) {
                                                    self.token = token
                                                }
                                            },
                                            failure: { error in
                                                print("***ERROR*** \(error)")
                                            }
        )
    }
    
    func getRequest(login: String, oauthswift: OAuthSwift, param: Dictionary<String,Any>, completionHandler: @escaping () -> Void)
    {
        let _ = oauthswift.client.get("https://api.intra.42.fr/v2/users/" + login, parameters: param,
                                      success: { response in
                                        if let tmp = (try? response.jsonObject() as? NSDictionary) {
                                            if let js = tmp{
//                                                print(js)
//                                                user = js
                                                self.student = Info(json_user: js)
                                            }
                                        }
                                        completionHandler()
                                    },
                                    failure: { error in
                                        print("ERROR \(error.localizedDescription)")
                                        self.errorLabel.isHidden = false
                                        self.outlet.text = ""
                                    }
        )
        
//        let _ = oauthswift.client.get("https://api.intra.42.fr/v2/users/:user_id/coalitions", parameters: param,
//                                      success: { response in
//                                        if let tmp = (try? response.jsonObject() as? NSDictionary) {
//                                            if let js = tmp{
//                                                print(js)
//                                                coalition = js
//                                            }
//                                        }
//                                        completionHandler()
//        },
//                                      failure: { error in
//                                        print("ERROR \(error.localizedDescription)")
//                                        self.errorLabel.isHidden = false
//                                        self.outlet.text = ""
//        }
//        )
////
////        self.student = Info(json_user: user!, json_coal: coalition!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

