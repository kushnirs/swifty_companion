//
//  SecondViewController.swift
//  swifty_companion
//
//  Created by Sergee on 8/7/18.
//  Copyright © 2018 Sergee. All rights reserved.
//

import UIKit
import DDSpiderChart
import LinearProgressBar

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
    
    @IBOutlet weak var coalitionLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var projectTableView: UITableView!
    
    @IBOutlet weak var skillsChartView: DDSpiderChartView!
    
    @IBOutlet weak var levelProgressBar: LinearProgressBar!
    
    @IBOutlet weak var levelLabel: UILabel!
    
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
            
            //MARK - edit coalitionLabel
            if student!.coalition != nil {
                coalitionLabel.isHidden = false
                if student!.coalition == "The Hive" {
                    coalitionLabel.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "hive")
                }
                else if student!.coalition == "The Union" {
                    coalitionLabel.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "union")
                }
                else if student!.coalition == "The Empire" {
                    coalitionLabel.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "empire")
                }
                else if student!.coalition == "The Allience" {
                    coalitionLabel.text = student!.coalition
                    backgroundImageView.image = UIImage(named: "Alliance")
                }
            }
            else {
                backgroundImageView.image = UIImage(named: "42")
            }
            
            //MARK - edit levelLabel
            if student!.level != nil {
                let fraction = student!.level!.truncatingRemainder(dividingBy: 1)
                let number = student!.level! - fraction
                levelLabel.text = "level " + String(Int(number)) + " - " + String(Int(fraction * 100)) + "%"
                levelProgressBar.progressValue = CGFloat(student!.level! * 100 / 16)
            } else {
                levelLabel.text = "level 0 - 0%"
                levelProgressBar.progressValue = 0
            }
            levelLabel.sizeToFit()
        }
        
        
    
        //MARK - add RadarChart
        skillsChartView.axes = student!.skillsName.map { attributedAxisLabelSample1($0) }
        skillsChartView.addDataSet(values: student!.skillsLevel, color: .cyan)
        // Do any additional setup after loading the view.
    }

    func attributedAxisLabelSample1(_ label: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: label, attributes: [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "AvenirNextCondensed-Bold", size: 10)!]))
        return attributedString
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
