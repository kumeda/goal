//
//  detailViewController.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/11/28.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    var goalId: Int = 0
    var currentGoal: Goal?
    var displayDay: NSDate = NSDate()
    var doneFlag: Bool = false
    var doneDisplayDay: Results<DoneDay>?
    
    @IBOutlet weak var goalTitleLabel: UILabel!
    @IBOutlet weak var achieveLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var detailView: DesignableView!
    @IBOutlet weak var calendarView: DesignableView!
    
    var myGoalViewController = GoalViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadView()
    }

    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        detailView.animation = "fall"
        detailView.animate()
    }

    @IBAction func editGoalDidTouched(sender: AnyObject) {
        performSegueWithIdentifier("editGoalSegue", sender: self.currentGoal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is GoalViewController {
            myGoalViewController = segue.destinationViewController as! GoalViewController
            myGoalViewController._goal = sender as? Goal
        }
    }
    
    func reloadView() {
        self.currentGoal = realm.objects(Goal).filter("id = \(goalId)").first
        self.goalTitleLabel.text = currentGoal!.goalTitle
        self.achieveLabel.text = "\(currentGoal!.achieveAmount) / \(currentGoal!.goalTotalAmount)"
        self.unitLabel.text = currentGoal!.goalUnit
        
        let myCalendarView:CalendarView = CalendarView(frame: CGRectMake(0, 5,
            calendarView.frame.width, calendarView.frame.height), goalId: goalId, sender:self);
        calendarView.addSubview(myCalendarView)
    }

}
