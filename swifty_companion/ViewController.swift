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
    var level: String?
    var location: String?
    var coalition: String?
    var projects = [(String, String)]()
    var skills = [(String, String)]()
    
    init(json_user: NSDictionary, json_coal: [NSDictionary])
    {
        //MARK - add basic information about student
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
        
        //MARK - add coalition
        if (json_coal.count > 0) {
            if let coalition = json_coal[0]["name"] {
                self.coalition = coalition as? String
            }
        }
        
        //MARK - add project iformation
        if let projects_users = json_user["projects_users"] {
            for project in (projects_users as! [NSDictionary]) {
                if ((project["cursus_ids"] as! [Int])[0]) == 1 {
                    var new_project = ("","")
                    let mark = project["final_mark"] as? Int
                    new_project.1 = mark != nil ? String(mark!) + "%" : "-"
                    if let project_info = project["project"] {
//                        print((project_info as! NSDictionary)["parent_id"] as? Int)
                        if (project_info as! NSDictionary)["parent_id"] as? Int == nil {
                            new_project.0 = (project_info as! NSDictionary)["name"] as! String
                            self.projects.append(new_project)
                        }
                    }
                }
            }
        }
        print(projects)
        var skillDict = [NSDictionary]()
        if let projects_users = json_user["cursus_users"] {
            for project in (projects_users as! [NSDictionary]) {
                if (project["cursus_id"] as! Int) == 1 {
                    if let skills = (project["skills"] as? [NSDictionary]) {
                        skillDict = skills
                    }
                }
            }
        }
        for skill in skillDict {
            var new_skill = ("","")
            let level = skill["level"] as? Double
            new_skill.1 = level != nil ? String(level!) : "-"
            let name = skill["name"] as? String
            new_skill.0 = name != nil ? name! : ""
            self.skills.append(new_skill)
        }
        print(skills)
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var outlet: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let oauthswift = OAuth1Swift(consumerKey: "", consumerSecret: "")
    
    var token = Dictionary<String,Any>()
    
    var student: Info?
    
//    @IBAction func action(_ sender: Any)
//    {
//        if self.outlet.text != "" {
//            errorLabel.isHidden = true
//        }
//
//        self.getRequest(login: outlet.text!,
//                        oauthswift: oauthswift,
//                        param: token,
//                        completionHandler: {
//                            self.performSegue(withIdentifier: "segue", sender: self) })
//    }
    
    
    @IBAction func action(_ sender: Any)
    {
        var user_id = String()
        var coalition = [NSDictionary()]
        
        let myCompletionHandler : (OAuthSwiftResponse) -> Void = {
            (user: OAuthSwiftResponse) in
            let json_user = try! user.jsonObject() as! NSDictionary
            if let cursus = json_user["campus_users"] as? [NSDictionary] {
                if let json_id = cursus[0]["user_id"] as? NSNumber {
                    user_id = json_id.stringValue
                    print(user_id)
                }
            }
            self.getRequest(url: "https://api.intra.42.fr/v2/users/" + user_id + "/coalitions",
                            oauthswift: self.oauthswift,
                            param: self.token,
                            completionHandler: {
                                (user: OAuthSwiftResponse) in
                                coalition = try! user.jsonObject() as! [NSDictionary]
                                self.student = Info(json_user: json_user, json_coal: coalition)
                                self.performSegue(withIdentifier: "segue", sender: self)
                            })
        }
        
        self.getRequest(url: "https://api.intra.42.fr/v2/users/" + outlet.text!,
                        oauthswift: oauthswift,
                        param: token,
                        completionHandler: myCompletionHandler)
        
        if self.outlet.text != "" {
            errorLabel.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let secondController = segue.destination as! SecondViewController
        secondController.student = self.student
    }
    
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
    
//    func getRequest(login: String, oauthswift: OAuthSwift, param: Dictionary<String,Any>, completionHandler: @escaping () -> Void)
//    {
//        let _ = oauthswift.client.get("https://api.intra.42.fr/v2/users/" + login, parameters: param,
//                                      success: { response in
//                                        if let tmp = (try? response.jsonObject() as? NSDictionary) {
//                                            if let js = tmp{
////                                                print(js)
////                                                user = js
//                                                self.student = Info(json_user: js)
//                                            }
//                                        }
//                                        completionHandler()
//                                    },
//                                    failure: { error in
//                                        print("ERROR \(error.localizedDescription)")
//                                        self.errorLabel.isHidden = false
//                                        self.outlet.text = ""
//                                    }
//        )
//    }
    
    func getRequest(url: String, oauthswift: OAuthSwift, param: Dictionary<String,Any>, completionHandler: @escaping (OAuthSwiftResponse) -> Void)
    {
        let _ = oauthswift.client.get(url, parameters: param,
                success: { response in
                    completionHandler(response)
                },
                failure: { error in
                    print("ERROR \(error.localizedDescription)")
                    self.errorLabel.isHidden = false
                    self.outlet.text = ""
                }
        )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

