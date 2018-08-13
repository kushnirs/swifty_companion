//
//  SecondViewController.swift
//  swifty_companion
//
//  Created by Sergee on 8/7/18.
//  Copyright © 2018 Sergee. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var userIMG: UIImageView!
    
    @IBOutlet weak var displaynameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var walletLabel: UILabel!
    
    @IBOutlet weak var correctionsLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var student: Info?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIMG.layer.cornerRadius = userIMG.frame.size.width / 2.4;
        userIMG.clipsToBounds = true;
        if  student != nil {
            displaynameLabel.text = student!.displayname
            displaynameLabel.sizeToFit()
            emailLabel.text = student!.email
            emailLabel.sizeToFit()
            loginLabel.text = student!.login
            loginLabel.sizeToFit()
            numberLabel.text = student!.number
            numberLabel.sizeToFit()
            walletLabel.text = student!.wallet
            walletLabel.sizeToFit()
            correctionsLabel.text = student!.corrections
            correctionsLabel.sizeToFit()
            gradeLabel.text = student!.grade
            gradeLabel.sizeToFit()
            if student!.location != nil {
                 locationLabel.text = student!.location
            }
            else{
                 locationLabel.text = "Unavailable"
            }
            locationLabel.sizeToFit()
            let urkKey = student!.userIMG!
            if let url = URL(string: urkKey) {
                do {
                    let data = try Data(contentsOf: url)
                    userIMG.image = UIImage(data: data)
                } catch let err {
                    print("Error : \(err.localizedDescription)")
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
