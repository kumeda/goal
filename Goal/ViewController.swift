//
//  ViewController.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/11/27.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    var displayDay: NSDate = NSDate()
    
    var myDetailViewController = DetailViewController()
    var myTopView: TopView?
    
    @IBOutlet weak var displayDayLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test data insert
        self.initializeData()
        
        myTopView = TopView(frame: CGRectMake(0, 70.0, self.view.bounds.width, self.view.bounds.height - 70.0), sender:self)
        
        self.reloadView()
        self.view.addSubview(myTopView!)
    }
    
    @IBAction func createButtonDidTouch(sender: AnyObject) {
        performSegueWithIdentifier("createGoalSegue", sender: self)
    }
    
    func reloadView() {
        self.updateDisplayDay(self.displayDay)
        myTopView!.setTopView()
    }
    
    func updateDisplayDay(date:NSDate) {
        let format: NSDateFormatter = NSDateFormatter()
        format.dateFormat = "MMM. dd"
        displayDayLabel.text = format.stringFromDate(date)
        
        self.displayDay = date
    }
    
    func goalButtonDidTouched(sender: UIButton){
        performSegueWithIdentifier("showDetailSegue", sender: sender.tag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is DetailViewController {
            myDetailViewController = segue.destinationViewController as! DetailViewController
            myDetailViewController.goalId = sender as! Int
            myDetailViewController.displayDay = self.displayDay
        }
    }
    
    func initializeData() {
        
        try! realm.write {
            realm.deleteAll()
        }
        
        var goal: Goal = Goal()
        let titleArray = ["English Grammer Text","Running For Marathon","Save Money Under 15$","test"]
        
        var i = 1
        for title in titleArray {
            goal = Goal()
            goal.id = i
            goal.goalTitle = title
            goal.goalTotalAmount = 25
            goal.taskPerDayAmount = 2
            goal.goalUnit = "day"
            goal.sunday = true
            goal.monday = false
            goal.tuesday = true
            goal.wednesday = false
            goal.thursday = true
            goal.friday = false
            goal.saturday = true
            if i == 1 {
                goal.goalStatus = GoalStatusConfig.PROGRESS
            } else if i == 2 {
                goal.goalStatus = GoalStatusConfig.COMPLETE
            } else if i == 3 {
                goal.goalStatus = GoalStatusConfig.GIVEUP
            } else {
                goal.goalStatus = GoalStatusConfig.PROGRESS
            }
            try! realm.write {
                realm.add(goal)
            }
            i++
        }
    }
}

