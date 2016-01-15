//
//  TopEachView.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/20.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class TopEachView: UIView {
    
    private let buttonSize: CGFloat = 105
    private let buttonInterval: CGFloat = 10
    private let buttonCornerR: CGFloat = 8.0
    private let viewMarginTop: CGFloat = 15
    private let viewMarginRight: CGFloat = 20
    private let viewMarginLeft: CGFloat = 20
    
    var displayDay: NSDate = NSDate()
    
    var parentViewController:ViewController?

    var myLongPressGesture: UILongPressGestureRecognizer?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, displayDay: NSDate, sender:AnyObject) {
        super.init(frame: frame);
        self.parentViewController = sender as? ViewController
        self.setGoalButton(displayDay)
    }
    
    func setGoalButton(displayDay:NSDate){
        self.displayDay = displayDay
        let subViews:[UIView] = self.subviews as [UIView]
        for view in subViews {
            view.removeFromSuperview()
        }
        
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Day , .Month, .Year ], fromDate: self.displayDay)
        let startOfDisplayDay = calendar.dateFromComponents(components)
        components.day += 1
        let startOfNextDay = calendar.dateFromComponents(components)
        
        var i = 0
        let interval: CGFloat = buttonSize + buttonInterval
        var refPointX: CGFloat?
        var refPointY: CGFloat?
        var goalButton: UIButton!
        var doneDays: Results<DoneDay>
        var doneFlag: Bool = false
        
        let progressGoals = realm.objects(Goal).filter("goalStatus == \(GoalStatusConfig.PROGRESS)")
        let completeGoals = realm.objects(Goal).filter("goalStatus == \(GoalStatusConfig.COMPLETE)")
        let giveupGoals = realm.objects(Goal).filter("goalStatus == \(GoalStatusConfig.GIVEUP)")
        
        for goals in [progressGoals, giveupGoals, completeGoals] {
            for goal in goals {
                doneFlag = false
                if i % 3 == 0 {
                    refPointX = viewMarginLeft + CGFloat(buttonSize/2)
                    refPointY = viewMarginTop + interval * CGFloat(i / 3) + CGFloat(buttonSize/2)
                } else if i % 3 == 1 {
                    refPointX = viewMarginLeft + interval + CGFloat(buttonSize/2)
                    refPointY = viewMarginTop + interval * CGFloat(i / 3) + CGFloat(buttonSize/2)
                } else if i % 3 == 2 {
                    refPointX = viewMarginLeft + interval * CGFloat(2) + CGFloat(buttonSize/2)
                    refPointY = viewMarginTop + interval * CGFloat(i / 3) + CGFloat(buttonSize/2)
                }
                
                doneDays = goal.doneDays.filter("doneDay >= %@ && doneDay < %@", startOfDisplayDay!, startOfNextDay!)
                if doneDays.count != 0 {
                    doneFlag = true
                }
                
                if goal.goalStatus == GoalStatusConfig.PROGRESS {
                    if !doneFlag {
                        goalButton = createButton(goal.goalTitle!, pos_x: refPointX!, pos_y: refPointY!, type: 0)
                    } else {
                        goalButton = createButton(goal.goalTitle!, pos_x: refPointX!, pos_y: refPointY!, type: 1)
                    }
                } else if goal.goalStatus == GoalStatusConfig.COMPLETE {
                    goalButton = createButton(goal.goalTitle!, pos_x: refPointX!, pos_y: refPointY!, type: 2)
                } else if goal.goalStatus == GoalStatusConfig.GIVEUP {
                    goalButton = createButton(goal.goalTitle!, pos_x: refPointX!, pos_y: refPointY!, type: 3)
                }

                goalButton.tag = goal.id
                self.addSubview(goalButton)
                if doneFlag {
                    let image:UIImage? = UIImage(named:"check.pdf")
                    let imageView = UIImageView(image:image)
                    imageView.frame = CGRectMake(refPointX! - CGFloat(42/2), refPointY! - CGFloat(32/2), CGFloat(42), CGFloat(32))
                    imageView.tag = goal.id + 10000
                    self.addSubview(imageView)
                }
                i += 1
            }
        }
    }

    func createButton(title: String, pos_x: CGFloat, pos_y: CGFloat, type: Int) -> UIButton {
        var myButton: DesignableButton!
        
        myButton = DesignableButton()
        myButton.frame = CGRectMake(0,0,buttonSize,buttonSize)
        myButton.layer.masksToBounds = true
        myButton.titleLabel?.numberOfLines = 0
        myButton.titleLabel?.font = FontConfig.GOAL_SMALL
        myButton.setTitle(title, forState: UIControlState.Normal)
        myButton.layer.cornerRadius = buttonCornerR
        myButton.layer.position = CGPoint(x: pos_x, y: pos_y)
        
        if type == 0 {
            myButton.backgroundColor = ColorConfig.GOAL_PINK
            myButton.setTitleColor(ColorConfig.GOAL_WHITE, forState: UIControlState.Normal)
        } else if type == 1 {
            myButton.backgroundColor = ColorConfig.GOAL_NAVY
            myButton.setTitleColor(ColorConfig.GOAL_GRAY, forState: UIControlState.Normal)
        } else if type == 2 {
            myButton.backgroundColor = ColorConfig.GOAL_GRAY
            myButton.setTitleColor(ColorConfig.GOAL_LIGHT_GRAY, forState: UIControlState.Normal)
            let compLabel = UILabel(frame: CGRectMake(myButton.frame.width - 60, myButton.frame.height - 25, 50, 18))
            compLabel.backgroundColor = ColorConfig.GOAL_NAVY
            compLabel.textAlignment = NSTextAlignment.Center
            compLabel.textColor = ColorConfig.GOAL_WHITE
            compLabel.font = FontConfig.GOAL_EX_SMALL
            compLabel.text = "COMP"
            myButton.addSubview(compLabel)
        } else if type == 3 {
            myButton.backgroundColor = ColorConfig.GOAL_GRAY
            myButton.setTitleColor(ColorConfig.GOAL_LIGHT_GRAY, forState: UIControlState.Normal)
        }
        
        myButton.addTarget(self.parentViewController, action: "goalButtonDidTouched:", forControlEvents: .TouchUpInside)
        myLongPressGesture = UILongPressGestureRecognizer(target: self, action: "goalButtonLongTouched:")
        myButton.addGestureRecognizer(myLongPressGesture!)
        return myButton
    }
    
    func goalButtonLongTouched(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began {
            let goalId = sender.view!.tag
            let goal = realm.objects(Goal).filter("id == \(goalId)").first
            if goal!.goalStatus != 1 {
                return
            }
            let myButton: DesignableButton = self.viewWithTag(goalId) as! DesignableButton
            var doneFlag: Bool = false
            var archiveFlag: Bool = false
            
            let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
            let components = calendar.components([.Day , .Month, .Year ], fromDate: self.displayDay)
            let startOfDisplayDay = calendar.dateFromComponents(components)
            components.day += 1
            let startOfNextDay = calendar.dateFromComponents(components)
            let doneDisplayDay = goal!.doneDays.filter("doneDay >= %@ && doneDay < %@", startOfDisplayDay!, startOfNextDay!)
            if doneDisplayDay.count != 0 {
                doneFlag = true
            }
            
            // update data
            if !doneFlag {
                let doneDay = DoneDay()
                doneDay.doneDay = self.displayDay
                doneDay.goal = goal!
                doneDay.taskAmount = goal!.taskPerDayAmount
                var doneDays = goal!.doneDays.map { $0 }
                doneDays.append(doneDay)
                let achieveDays = goal!.achieveDays + 1
                let achieveAmount = goal!.achieveAmount + goal!.taskPerDayAmount
                let achieveRate = Int(achieveDays / goal!.goalTotalAmount)
                var goalStatus = goal!.goalStatus
                if achieveAmount > goal!.goalTotalAmount {
                    goalStatus = GoalStatusConfig.COMPLETE
                    archiveFlag = true
                }
                try! realm.write {
                    realm.add(doneDay)
                    realm.create(Goal.self, value: ["id": goal!.id, "doneDays": doneDays, "achieveDays": achieveDays, "achieveAmount": achieveAmount, "achieveRate": achieveRate, "goalStatus": goalStatus], update: true)
                }
            } else {
                let achieveDays = goal!.achieveDays - 1
                let achieveAmount = goal!.achieveAmount - goal!.taskPerDayAmount
                let achieveRate = Int(achieveAmount / goal!.goalTotalAmount)
                var goalStatus = goal!.goalStatus
                if achieveAmount < goal!.goalTotalAmount {
                    goalStatus = GoalStatusConfig.PROGRESS
                }
                try! realm.write {
                    realm.delete(doneDisplayDay)
                    realm.create(Goal.self, value: ["id": goal!.id, "achieveDays": achieveDays, "achieveAmount": achieveAmount, "achieveRate": achieveRate, "goalStatus": goalStatus], update: true)
                }
            }
            
            // update view
            if !doneFlag {
                myButton.backgroundColor = ColorConfig.GOAL_NAVY
                myButton.setTitleColor(ColorConfig.GOAL_GRAY, forState: UIControlState.Normal)
                
                let image:UIImage? = UIImage(named:"check.pdf")
                let imageView = UIImageView(image:image)
                let refPointX = myButton.frame.width/2
                let refPointY = myButton.frame.height/2
                imageView.frame = CGRectMake(refPointX - CGFloat(42/2), refPointY - CGFloat(32/2), CGFloat(42), CGFloat(32))
                imageView.tag = goalId + 10000
                myButton.addSubview(imageView)
                if archiveFlag {
                    myButton.animation = "pop"
                    myButton.animate()
                    myButton.backgroundColor = ColorConfig.GOAL_GRAY
                    myButton.setTitleColor(ColorConfig.GOAL_LIGHT_GRAY, forState: UIControlState.Normal)
                }
            } else {
                myButton.backgroundColor = ColorConfig.GOAL_PINK
                myButton.setTitleColor(ColorConfig.GOAL_WHITE, forState: UIControlState.Normal)
                
                let subViews:[UIView] = myButton.subviews as [UIView]
                for view in subViews {
                    if view.isKindOfClass(UIImageView) {
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }
}