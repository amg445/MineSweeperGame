//
//  SidePanelViewController.swift
//  MineSweeper
//
//  Created by Logan Allen on 12/29/15.
//  Copyright © 2015 Andrew Grossfeld. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController {
    
    var introVC: IntroViewController?

    @IBOutlet weak var themeSeg: UISegmentedControl!
    @IBOutlet weak var boardSeg: UISegmentedControl!
    @IBOutlet weak var levelSeg: UISegmentedControl!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attemptsLabel: UILabel!
    @IBOutlet weak var winsLabel: UILabel!
    @IBOutlet weak var lossesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var bottomImage: UIImageView!
    
    @IBOutlet weak var clearButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let theme = NSUserDefaults.standardUserDefaults().valueForKey("theme") as! String
        setTheme(theme)
        boardSeg.selectedSegmentIndex = (introVC?.gameType)!
        levelSeg.selectedSegmentIndex = (introVC?.gameLevel)!
        
        // Set title's color and shadow
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.layer.shadowColor = UIColor.blackColor().CGColor
        titleLabel.layer.shadowOffset = CGSizeMake(2,2)
        titleLabel.layer.shadowOpacity = 0.6
        titleLabel.layer.shadowRadius = 1
        
        // Set bottom image's shadow
        bottomImage.layer.shadowColor = UIColor.blackColor().CGColor
        bottomImage.layer.shadowOffset = CGSizeMake(4, 3)
        bottomImage.layer.shadowOpacity = 0.6
        bottomImage.layer.shadowRadius = 2
        
        // Set clear data button's shadow
        clearButton.layer.shadowOpacity = 0.7
        clearButton.layer.shadowOffset = CGSizeMake(4, 4)
        clearButton.layer.shadowRadius = 4
        clearButton.layer.shadowColor = UIColor.blackColor().CGColor
        
        showData()
    }
    
    // Update the text displaying the times and attempts
    func showData(){
        let key: String = getKey()
        let time = NSUserDefaults.standardUserDefaults().valueForKey(key) as! Int
        let losses = NSUserDefaults.standardUserDefaults().valueForKey("\(key)Fails") as! Int
        let wins = NSUserDefaults.standardUserDefaults().valueForKey("\(key)Wins") as! Int
        let attempts = losses + wins
        
        attemptsLabel.text = "\(attempts)"
        winsLabel.text = "\(wins)"
        lossesLabel.text = "\(losses)"
        timeLabel.text = timeToText(time)
    }
    
    // Get the key for NSUserDefault
    func getKey() -> String{
        let num = 8 + 2*boardSeg.selectedSegmentIndex
        var diff: String = ""
        
        if levelSeg.selectedSegmentIndex == 0{
            diff = "Easy"
        }else if levelSeg.selectedSegmentIndex == 1{
            diff = "Medium"
        }else{
            diff = "Hard"
        }
        
        return "\(num)\(diff)"
    }
    
    // Convert time to minutes and seconds
    func timeToText(score: Int) -> String {
        var time: String = ""
        
        if (score == 0) {
            time = "unknown"
        }
        else {
            let mins = score / 60
            let secs = score % 60
            if (secs < 10) {
                time = "\(mins): 0\(secs)"
            }
            else {
                time = "\(mins): \(secs)"
            }
        }
        return time
    }
    
    // Set the theme depending on Day or Night
    func setTheme(theme: String){
        if theme == "Day"{
            backgroundImage.image = UIImage(named: "sky")
            bottomImage.layer.opacity = 1.0
            themeSeg.selectedSegmentIndex = 0
        }else{
            backgroundImage.image = UIImage(named: "nightSky")
            bottomImage.layer.opacity = 0.7
            themeSeg.selectedSegmentIndex = 1
        }
        
        for view in self.view.subviews {
            (view as? UILabel)?.textColor = Style.textColor
            (view as? UISegmentedControl)?.tintColor = UIColor.whiteColor()
            (view as? UISegmentedControl)?.layer.shadowColor = UIColor.blackColor().CGColor
            (view as? UISegmentedControl)?.layer.shadowOffset = CGSizeMake(3,3)
            (view as? UISegmentedControl)?.layer.shadowRadius = 3
            (view as? UISegmentedControl)?.layer.shadowOpacity = 0.7
        }
    }
    
    // Switch between themes
    @IBAction func themeSegment(sender: UISegmentedControl) {
        var theme: String = ""
        if sender.selectedSegmentIndex == 0{
            NSUserDefaults.standardUserDefaults().setValue("Day", forKey: "theme")
            theme = "Day"
        }else{
            NSUserDefaults.standardUserDefaults().setValue("Night", forKey: "theme")
            theme = "Night"
        }
        Style.changeTheme()
        setTheme(theme)
        introVC?.viewWillAppear(true)
    }
    
    @IBAction func boardSegment(sender: UISegmentedControl) {
        introVC?.gameType = sender.selectedSegmentIndex
        showData()
    }
    @IBAction func levelSegment(sender: UISegmentedControl) {
        introVC?.gameLevel = sender.selectedSegmentIndex
        showData()
    }
    
    // Clear data for selected board & level
    @IBAction func clearScores(sender: UIButton) {
        let key: String = getKey()
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "\(key)Fails")
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: "\(key)Wins")
        NSUserDefaults.standardUserDefaults().setValue(0, forKey: key)
        showData()
    }

}
