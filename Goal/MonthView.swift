//
//  MonthView.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/11.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import Foundation

class MonthView: UIView {
    
    var goalId:Int!
    var lastDays:[Int]!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, year:Int, month:Int, goalId:Int) {
        super.init(frame: frame);
        
        self.goalId = goalId
        
        self.lastDays = {() -> [Int] in
            if(year % 400 == 0 || (year % 4 == 0 && year % 100 != 0)){
                return [31,29,31,30,31,30,31,31,30,31,30,31];
            }
            return [31,28,31,30,31,30,31,31,30,31,30,31];
            }()
        
        self.setUpDays(year,month:month)
    }
    
    func setUpDays(year:Int,month:Int){
        
        let subViews:[UIView] = self.subviews as [UIView]
        for view in subViews {
            if view.isKindOfClass(DayView) {
                view.removeFromSuperview()
            }
        }
        
        let day:Int? = self.lastDays[month-1];
        let dayWidth:Int = Int( frame.size.width / 7.0 )
        let dayHeight:Int = Int( frame.size.height / 6.0 )

        // get doneDayArray and today
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        var doneDayArray:[Int] = []
        let goal = realm.objects(Goal).filter("id = \(goalId)").first
        let startOfMonth = getStartOfMonth(year, month: month)
        let startOfNextMonth = getStartOfNextMonth(year, month: month)
        let doneDays = goal!.doneDays.filter("doneDay >= %@ && doneDay < %@", startOfMonth, startOfNextMonth)
        for d in doneDays {
            let comps:NSDateComponents = calendar!.components(NSCalendarUnit.Day, fromDate: d.doneDay!)
            doneDayArray.append(comps.day)
        }
        var today:Int?
        if year == calendar!.component(.Year, fromDate: NSDate()) && month == calendar!.component(.Month, fromDate: NSDate()) {
            today = calendar!.component(.Day, fromDate: NSDate())
        }
        
        if day != nil {
            var weekday:Int = self.getWeekDay(year,month: month,day:1)
            var week:Int    = 0

            if weekday == 1 {
                weekday = 8;
            }
            
            for var i:Int = 0; i < day!;i++ {
                let x:Int       = ((weekday - 2) * (dayWidth));
                let y:Int       = week * dayHeight
                let frame:CGRect = CGRectMake(CGFloat(x),
                    CGFloat(y),
                    CGFloat(dayWidth),
                    CGFloat(dayHeight)
                );

                var dayView:DayView!
                if (today != nil && today == (i+1)) {
                    dayView = DayView(frame: frame, year:year,month:month,day:i+1,type:2)
                } else if doneDayArray.contains(i+1) {
                    dayView  = DayView(frame: frame, year:year,month:month,day:i+1,type:1)
                } else {
                    dayView = DayView(frame: frame, year:year,month:month,day:i+1,type:0)
                }
                self.addSubview(dayView)
                
                weekday++
                if weekday > 8 {
                    weekday = 2; week += 1
                }
            }
        }
    }

    func getWeekDay(year:Int,month:Int,day:Int) ->Int{
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let date:NSDate? = dateFormatter.dateFromString(String(format:"%04d/%02d/%02d",year,month,day));
        if date != nil {
            let calendar:NSCalendar = NSCalendar.currentCalendar()
            let dateComp:NSDateComponents = calendar.components(NSCalendarUnit.Weekday, fromDate: date!)
            return dateComp.weekday;
        }
        return 0;
    }
    
    func getStartOfMonth(year:Int,month:Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date)
        components.year = year
        components.month = month
        components.day = 1
        return calendar.dateFromComponents(components)!
    }
    
    func getStartOfNextMonth(year:Int,month:Int) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let date = NSDate()
        let components = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date)
        if month == 12 {
            components.year = year + 1
            components.month = 1
        } else {
            components.year = year
            components.month = month + 1
        }
        components.day = 1
        return calendar.dateFromComponents(components)!
    }
    
}