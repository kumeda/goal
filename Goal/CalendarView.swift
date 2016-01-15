//
//  CalendarView.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/11.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import Foundation

class CalendarView: UIView,UIScrollViewDelegate{
    
    var currentYear:Int = 0
    var currentMonth:Int = 0
    var currentDay:Int = 0
    var headerHeight: CGFloat!
    var scrollView:UIScrollView!
    var prevMonthView:MonthView!
    var currentMonthView:MonthView!
    var nextMonthView:MonthView!
    var prevHeaderView:MonthHeaderView!
    var currentHeaderView:MonthHeaderView!
    var nextHeaderView:MonthHeaderView!
    
    var parentViewController:DetailViewController?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(frame:CGRect, goalId:Int, sender: AnyObject){
        super.init(frame: frame)
        
        let dateFormatter:NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy/MM/dd";
        let dateString:String = dateFormatter.stringFromDate(NSDate());
        var dates:[String] = dateString.componentsSeparatedByString("/")
        
        currentYear  = Int(dates[0])!
        currentMonth = Int(dates[1])!
        
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.contentSize   = CGSizeMake(frame.size.width,frame.size.height * 3.0);
        scrollView.contentOffset = CGPointMake(0.0 , frame.size.height);
        scrollView.delegate = self;
        scrollView.pagingEnabled = true;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.scrollsToTop = false;
        
        self.addSubview(scrollView)
        
        headerHeight = CGFloat(frame.size.height * 1 / 7)

        var ret = self.getPrevYearAndMonth()
        prevHeaderView =  MonthHeaderView(frame: CGRectMake(0, 0, frame.size.width, headerHeight),
            year:ret.year,month:ret.month, goalId:goalId)
        prevMonthView = MonthView(frame: CGRectMake(0.0, headerHeight, frame.size.width, frame.size.height - headerHeight),
            year:ret.year,month:ret.month, goalId:goalId)
        
        currentHeaderView = MonthHeaderView(frame: CGRectMake(0, frame.size.height, frame.size.width, headerHeight),
            year:currentYear,month:currentMonth, goalId:goalId)
        currentMonthView = MonthView(frame: CGRectMake(0, frame.size.height + headerHeight, frame.size.width, frame.size.height - headerHeight),
            year:currentYear,month:currentMonth, goalId:goalId)
        
        ret = self.getNextYearAndMonth()
        nextHeaderView =  MonthHeaderView(frame: CGRectMake(0, frame.size.height * 2.0, frame.size.width, headerHeight),
            year:ret.year,month:ret.month, goalId:goalId)
        nextMonthView =  MonthView(frame: CGRectMake(0, frame.size.height * 2.0 + headerHeight, frame.size.width, frame.size.height - headerHeight),
            year:ret.year,month:ret.month, goalId:goalId)
        
        scrollView.addSubview(prevHeaderView);
        scrollView.addSubview(prevMonthView);
        scrollView.addSubview(currentHeaderView);
        scrollView.addSubview(currentMonthView);
        scrollView.addSubview(nextHeaderView);
        scrollView.addSubview(nextMonthView);
        
        self.parentViewController = sender as? DetailViewController
        self.parentViewController?.monthLabel.text = String(format:"%04d.%02d", currentYear, currentMonth)
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView)
    {
        let pos:CGFloat  = scrollView.contentOffset.y / scrollView.bounds.size.height
        let deff:CGFloat = pos - 1.0
        if fabs(deff) >= 1.0 {
            if (deff > 0) {
                self.showNextView()
            } else {
                self.showPrevView()
            }
        }
    }
    
    func showNextView (){
        currentMonth++;
        if( currentMonth > 12 ){
            currentMonth = 1;
            currentYear++;
        }
        self.parentViewController?.monthLabel.text = String(format:"%04d.%02d", currentYear, currentMonth)

        let ret = self.getNextYearAndMonth()

        let tmpHeaderView:MonthHeaderView = currentHeaderView
        currentHeaderView = nextHeaderView
        nextHeaderView    = prevHeaderView
        prevHeaderView    = tmpHeaderView
        nextHeaderView.setHeader(ret.year, month:ret.month)
        
        let tmpView:MonthView = currentMonthView
        currentMonthView = nextMonthView
        nextMonthView    = prevMonthView
        prevMonthView    = tmpView
        nextMonthView.setUpDays(ret.year, month:ret.month)
        
        self.resetContentOffSet()
    }

    func showPrevView () {
        currentMonth--
        if( currentMonth == 0 ){
            currentMonth = 12
            currentYear--
        }
        self.parentViewController?.monthLabel.text = String(format:"%04d.%02d", currentYear, currentMonth)

        let ret = self.getPrevYearAndMonth()

        let tmpHeaderView:MonthHeaderView = currentHeaderView
        currentHeaderView = prevHeaderView
        prevHeaderView    = nextHeaderView
        nextHeaderView    = tmpHeaderView
        prevHeaderView.setHeader(ret.year, month:ret.month)
        
        let tmpView:MonthView = currentMonthView
        currentMonthView = prevMonthView
        prevMonthView    = nextMonthView
        nextMonthView    = tmpView
        prevMonthView.setUpDays(ret.year, month:ret.month)
        
        self.resetContentOffSet()
    }
    
    //adjust position
    func resetContentOffSet () {
        prevHeaderView.frame = CGRectMake(0, 0, frame.size.width, headerHeight)
        currentHeaderView.frame = CGRectMake(0, frame.size.height, frame.size.width, headerHeight)
        nextHeaderView.frame = CGRectMake(0, frame.size.height * 2.0, frame.size.width, headerHeight)

        prevMonthView.frame = CGRectMake(0.0, headerHeight, frame.size.width, frame.size.height - headerHeight)
        currentMonthView.frame = CGRectMake(0, frame.size.height + headerHeight, frame.size.width, frame.size.height - headerHeight)
        nextMonthView.frame = CGRectMake(0, frame.size.height * 2.0 + headerHeight, frame.size.width, frame.size.height - headerHeight)
        
        let scrollViewDelegate:UIScrollViewDelegate = scrollView.delegate!
        scrollView.delegate = nil
        scrollView.contentOffset = CGPointMake(0.0 , frame.size.height);
        scrollView.delegate = scrollViewDelegate
    }
    
    func getNextYearAndMonth () -> (year:Int,month:Int){
        var next_year:Int = currentYear
        var next_month:Int = currentMonth + 1
        if next_month > 12 {
            next_month=1
            next_year++
        }
        return (next_year,next_month)
    }
    func getPrevYearAndMonth () -> (year:Int,month:Int){
        var prev_year:Int = currentYear
        var prev_month:Int = currentMonth - 1
        if prev_month == 0 {
            prev_month = 12
            prev_year--
        }
        return (prev_year,prev_month)
    }
}
