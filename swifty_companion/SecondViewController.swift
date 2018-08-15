//
//  SecondViewController.swift
//  swifty_companion
//
//  Created by Sergee on 8/7/18.
//  Copyright © 2018 Sergee. All rights reserved.
//

import UIKit
import Charts
import DDSpiderChart

class SecondViewController: UIViewController, UITableViewDataSource, UITabBarDelegate {

    @IBOutlet weak var userIMG: UIImageView!
    
    @IBOutlet weak var displaynameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    @IBOutlet weak var walletLabel: UILabel!
    
    @IBOutlet weak var correctionsLabel: UILabel!
    
    @IBOutlet weak var gradeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var coalitionLable: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var projectTableView: UITableView!
    
    @IBOutlet weak var skillsChartView: DDSpiderChartView!
    
    var student: Info?
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let count = student != nil ? student!.projects.count : 0
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! SwiftyTableViewCell
        if student != nil {
            cell.projectNameLabel.text = student!.projects[indexPath.row].0
            cell.projectMarkLabel.text = student!.projects[indexPath.row].1
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.projectTableView.rowHeight = 44.0
    
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
            if student!.coalition != nil {
                coalitionLable.isHidden = false
                if student!.coalition == "The Hive" {
                    coalitionLable.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "hive")
                }
                else if student!.coalition == "The Union" {
                    coalitionLable.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "union")
                }
                else if student!.coalition == "The Empire" {
                    coalitionLable.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "empire")
                }
                else if student!.coalition == "The Allience" {
                    coalitionLable.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "Alliance")
                }
            }
            else {
                backgroundImageView.image = UIImage(named: "42")
            }
        }
        
        
    
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
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
