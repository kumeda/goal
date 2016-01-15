//
//  GoalViewController.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/11/28.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit

class GoalViewController: UIViewController {
    
    var _goal:Goal?
    var taskDayOfWeek : [Bool] = [false,false,false,false,false,false,false]
    var formBool: Bool = true
    
    @IBOutlet weak var titleTextField: DesignableTextField!
    @IBOutlet weak var totalAmountTextField: DesignableTextField!
    @IBOutlet weak var perDayAmountTextField: DesignableTextField!
    @IBOutlet weak var unitTextField: DesignableTextField!
    @IBOutlet weak var createGoalButton: DesignableButton!
    @IBOutlet weak var archiveGoalButton: DesignableButton!
    @IBOutlet weak var deleteGoalButton: DesignableButton!
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (_goal == nil) {
            self.createGoalButton.setTitle("Create", forState: .Normal)
            self.createGoalButton.titleLabel?.font = FontConfig.GOAL_LARGE
            self.createGoalButton.setTitleColor(ColorConfig.GOAL_WHITE, forState: UIControlState.Normal)
            self.archiveGoalButton.hidden = true
            self.deleteGoalButton.hidden = true
            self.formBool = true
        } else {
            self.setFormValues()
            
            if (_goal!.goalStatus == GoalStatusConfig.PROGRESS) {
                self.formBool = true
                
                self.createGoalButton.setTitle("Update", forState: .Normal)
                self.createGoalButton.titleLabel?.font = FontConfig.GOAL_LARGE
                self.createGoalButton.setTitleColor(ColorConfig.GOAL_WHITE, forState: UIControlState.Normal)
                self.createGoalButton.hidden = false
                
                self.archiveGoalButton.setTitle("Give Up", forState: .Normal)
                self.archiveGoalButton.titleLabel?.font = FontConfig.GOAL_LARGE
                self.archiveGoalButton.setTitleColor(ColorConfig.GOAL_DUST, forState: UIControlState.Normal)
                self.archiveGoalButton.hidden = false
                self.deleteGoalButton.hidden = false
            } else if (_goal!.goalStatus == GoalStatusConfig.COMPLETE) {
                self.formBool = false

                self.createGoalButton.hidden = true
                self.archiveGoalButton.hidden = true
                self.deleteGoalButton.hidden = false
            } else if(_goal!.goalStatus == GoalStatusConfig.GIVEUP) {
                self.formBool = false
                
                self.createGoalButton.setTitle("Update", forState: .Normal)
                self.createGoalButton.titleLabel?.font = FontConfig.GOAL_LARGE
                self.createGoalButton.setTitleColor(ColorConfig.GOAL_WHITE, forState: UIControlState.Normal)
                self.createGoalButton.hidden = false
                
                self.archiveGoalButton.setTitle("Restart", forState: .Normal)
                self.archiveGoalButton.titleLabel?.font = FontConfig.GOAL_LARGE
                self.archiveGoalButton.setTitleColor(ColorConfig.GOAL_DUST, forState: UIControlState.Normal)
                self.archiveGoalButton.hidden = false
                self.deleteGoalButton.hidden = false
            }
        }
        self.formActivate(self.formBool)
    }
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // Everyday? toggle button action
    @IBAction func mondayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[1] {
            sender.setBackgroundImage(UIImage(named: "Week_M_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_M_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[1] = !taskDayOfWeek[1]
    }
    
    @IBAction func tuesdayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[2] {
            sender.setBackgroundImage(UIImage(named: "Week_T_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_T_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[2] = !taskDayOfWeek[2]
    }
    
    @IBAction func wednesdayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[3] {
            sender.setBackgroundImage(UIImage(named: "Week_W_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_W_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[3] = !taskDayOfWeek[3]
    }
    
    @IBAction func thursdayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[4] {
            sender.setBackgroundImage(UIImage(named: "Week_T_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_T_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[4] = !taskDayOfWeek[4]
    }
    
    @IBAction func fridayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[5] {
            sender.setBackgroundImage(UIImage(named: "Week_F_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_F_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[5] = !taskDayOfWeek[5]
    }
    
    @IBAction func saturdayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[6] {
            sender.setBackgroundImage(UIImage(named: "Week_S_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_S_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[6] = !taskDayOfWeek[6]
    }
    
    @IBAction func sundayDidTouch(sender: UIButton) {
        if !taskDayOfWeek[0] {
            sender.setBackgroundImage(UIImage(named: "Week_S_on.pdf"), forState: UIControlState.Normal)
        } else {
            sender.setBackgroundImage(UIImage(named: "Week_S_off.pdf"), forState: UIControlState.Normal)
        }
        taskDayOfWeek[0] = !taskDayOfWeek[0]
    }
    
    @IBAction func createGoalDidTouch(sender: AnyObject) {
        let goal = Goal()

        if (_goal != nil) {
            goal.id = _goal!.id
            goal.achieveDays = _goal!.achieveDays
            goal.achieveAmount = _goal!.achieveAmount
            goal.achieveRate = _goal!.achieveRate
        } else {
            goal.id = realm.objects(Goal).count + 1
            goal.achieveDays = 0
            goal.achieveAmount = 0
            goal.achieveRate = 0
        }
        goal.goalTitle = titleTextField.text!
        goal.goalTotalAmount = Int(totalAmountTextField.text!)!
        goal.taskPerDayAmount = Int(perDayAmountTextField.text!)!
        goal.goalUnit = unitTextField.text!

        if goal.achieveAmount < goal.goalTotalAmount {
            goal.goalStatus = GoalStatusConfig.PROGRESS
        } else {
            goal.goalStatus = GoalStatusConfig.COMPLETE
        }
        
        goal.sunday = taskDayOfWeek[0]
        goal.monday = taskDayOfWeek[1]
        goal.tuesday = taskDayOfWeek[2]
        goal.wednesday = taskDayOfWeek[3]
        goal.thursday = taskDayOfWeek[4]
        goal.friday = taskDayOfWeek[5]
        goal.saturday = taskDayOfWeek[6]
        
        // TODO: validation
        
        try! realm.write {
            realm.add(goal, update: true)
        }

        if let parentView = self.presentingViewController as? ViewController {
            parentView.reloadView()
        } else if let parentView = self.presentingViewController as? DetailViewController {
            parentView.reloadView()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func archiveGoalDidTouch(sender: AnyObject) {
        var goalStatus: Int?
        
        self.formBool = !self.formBool
        if self.formBool {
            goalStatus = GoalStatusConfig.PROGRESS
        } else {
            goalStatus = GoalStatusConfig.GIVEUP
        }
        
        self.formActivate(self.formBool)
        try! realm.write {
            realm.create(Goal.self, value: ["id": self._goal!.id, "goalStatus": goalStatus!], update: true)
        }
    }
    
    @IBAction func deleteGoalDidTouch(sender: AnyObject) {
        try! realm.write {
            realm.create(Goal.self, value: ["id": self._goal!.id, "goalStatus": GoalStatusConfig.DELETED], update: true)
        }
        if let parentViewController = self.presentingViewController as? DetailViewController {
            self.dismissViewControllerAnimated(false, completion: {
                parentViewController.dismissViewControllerAnimated(true, completion: nil)
                let grandparentViewController = parentViewController.presentingViewController as! ViewController
                grandparentViewController.reloadView()
            })
        }
    }
    
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {}
    
    func setFormValues() {
        self.titleTextField.text = _goal!.goalTitle!
        self.totalAmountTextField.text = String(_goal!.goalTotalAmount)
        self.perDayAmountTextField.text = String(_goal!.taskPerDayAmount)
        self.unitTextField.text = _goal!.goalUnit!
        self.taskDayOfWeek = [_goal!.sunday,_goal!.monday,_goal!.tuesday,_goal!.wednesday,_goal!.thursday,_goal!.friday,_goal!.saturday]
        
        if _goal!.sunday {
            self.sundayButton.setBackgroundImage(UIImage(named: "Week_S_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.sundayButton.setBackgroundImage(UIImage(named: "Week_S_off.pdf"), forState: UIControlState.Normal)
        }
        if _goal!.monday {
            self.mondayButton.setBackgroundImage(UIImage(named: "Week_M_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.mondayButton.setBackgroundImage(UIImage(named: "Week_M_off.pdf"), forState: UIControlState.Normal)
        }
        if _goal!.tuesday {
            self.tuesdayButton.setBackgroundImage(UIImage(named: "Week_T_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.tuesdayButton.setBackgroundImage(UIImage(named: "Week_T_off.pdf"), forState: UIControlState.Normal)
        }
        if _goal!.wednesday {
            self.wednesdayButton.setBackgroundImage(UIImage(named: "Week_W_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.wednesdayButton.setBackgroundImage(UIImage(named: "Week_W_off.pdf"), forState: UIControlState.Normal)
        }
        if _goal!.thursday {
            self.thursdayButton.setBackgroundImage(UIImage(named: "Week_T_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.thursdayButton.setBackgroundImage(UIImage(named: "Week_T_off.pdf"), forState: UIControlState.Normal)
        }
        if _goal!.friday {
            self.fridayButton.setBackgroundImage(UIImage(named: "Week_F_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.fridayButton.setBackgroundImage(UIImage(named: "Week_F_off.pdf"), forState: UIControlState.Normal)
        }
        if _goal!.saturday {
            self.saturdayButton.setBackgroundImage(UIImage(named: "Week_S_on.pdf"), forState: UIControlState.Normal)
        } else {
            self.saturdayButton.setBackgroundImage(UIImage(named: "Week_S_off.pdf"), forState: UIControlState.Normal)
        }
    }
    
    func formActivate(bool: Bool) {
        self.createGoalButton.enabled = bool
        if bool {
            self.createGoalButton.backgroundColor = ColorConfig.GOAL_PINK
            self.archiveGoalButton.setTitle("Archive", forState: UIControlState.Normal)
        } else {
            self.createGoalButton.backgroundColor = ColorConfig.GOAL_LIGHT_GRAY
            self.archiveGoalButton.setTitle("Restart", forState: UIControlState.Normal)
        }

        for ui in [self.titleTextField, self.totalAmountTextField, self.perDayAmountTextField, self.unitTextField] {
            ui.enabled = bool
            if bool {
                ui.textColor = ColorConfig.GOAL_NAVY
                ui.backgroundColor = ColorConfig.GOAL_WHITE
            } else {
                ui.textColor = ColorConfig.GOAL_GRAY
                ui.backgroundColor = ColorConfig.GOAL_LIGHT_GRAY
            }
        }

        for ui in [self.sundayButton, self.mondayButton, self.tuesdayButton, self.wednesdayButton, self.thursdayButton, self.fridayButton, self.saturdayButton] {
            ui.enabled = bool
        }
    }
}
