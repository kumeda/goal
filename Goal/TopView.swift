//
//  TopView.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/20.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift

class TopView: UIView,UIScrollViewDelegate {
    
    var displayDay: NSDate = NSDate()
    
    var scrollView:UIScrollView!
    var prevTopView:TopEachView?
    var currentTopView:TopEachView?
    var nextTopView:TopEachView?
    
    var parentViewController:ViewController?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, sender:AnyObject) {
        super.init(frame: frame);
        
        self.displayDay = sender.displayDay
        self.parentViewController = sender as? ViewController
        
        scrollView = UIScrollView(frame: CGRectMake(0,0,frame.size.width,frame.size.height))
        scrollView.backgroundColor = ColorConfig.GOAL_WHITE
        scrollView.contentSize   = CGSizeMake(frame.size.width * 3.0,frame.size.height);
        scrollView.contentOffset = CGPointMake(frame.size.width , 0.0);
        scrollView.delegate = self;
        scrollView.pagingEnabled = true;
        scrollView.showsHorizontalScrollIndicator = false;
        scrollView.showsVerticalScrollIndicator = false;
        scrollView.scrollsToTop = false;
        self.addSubview(scrollView)
    }
    
    func setTopView() {
        let subViews:[UIView] = scrollView.subviews as [UIView]
        for view in subViews {
            if view.isKindOfClass(TopEachView) {
                view.removeFromSuperview()
            }
        }

        let frame = self.bounds
        prevTopView = TopEachView(frame: CGRectMake(0.0, 0.0, frame.size.width, frame.size.height), displayDay: self.prevDay(self.displayDay),sender: self.parentViewController!)
        currentTopView = TopEachView(frame: CGRectMake(frame.size.width, 0.0, frame.size.width, frame.size.height), displayDay: self.displayDay, sender: self.parentViewController!)
        nextTopView = TopEachView(frame: CGRectMake(frame.size.width * 2.0, 0.0, frame.size.width, frame.size.height), displayDay: self.nextDay(self.displayDay), sender: self.parentViewController!)
        
        scrollView.addSubview(prevTopView!);
        scrollView.addSubview(currentTopView!);
        scrollView.addSubview(nextTopView!);
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView)
    {
        let pos:CGFloat  = scrollView.contentOffset.x / scrollView.bounds.size.width
        let deff:CGFloat = pos - 1.0
        if fabs(deff) >= 1.0 {
            if (deff > 0) {
                self.showNextView()
            } else {
                self.showPrevView()
            }
        }
    }

    func showNextView() {
        self.displayDay = nextDay(self.displayDay)

        let tmpTopView:TopEachView = currentTopView!
        currentTopView = nextTopView
        nextTopView    = prevTopView
        prevTopView    = tmpTopView
        nextTopView?.setGoalButton(nextDay(self.displayDay))
        
        self.parentViewController!.updateDisplayDay(self.displayDay)
        
        self.resetContentOffSet()
    }
    
    func showPrevView() {
        self.displayDay = prevDay(self.displayDay)
        
        let tmpTopView:TopEachView = currentTopView!
        currentTopView = prevTopView
        prevTopView    = nextTopView
        nextTopView    = tmpTopView
        prevTopView?.setGoalButton(prevDay(self.displayDay))
        
        self.parentViewController!.updateDisplayDay(self.displayDay)
        
        self.resetContentOffSet()
    }
    
    func resetContentOffSet() {
        let frame = self.bounds
        prevTopView!.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        currentTopView!.frame = CGRectMake(frame.size.width, 0.0, frame.size.width, frame.size.height)
        nextTopView!.frame = CGRectMake(frame.size.width * 2.0, 0.0, frame.size.width, frame.size.height)
        
        let scrollViewDelegate:UIScrollViewDelegate = scrollView.delegate!
        scrollView.delegate = nil
        scrollView.contentOffset = CGPointMake(frame.size.width , 0.0);
        scrollView.delegate = scrollViewDelegate
    }
    
    func prevDay(date:NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Day , .Month, .Year ], fromDate: self.displayDay)
        components.day -= 1
        return calendar.dateFromComponents(components)!
    }
    
    func nextDay(date:NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components([.Day , .Month, .Year ], fromDate: self.displayDay)
        components.day += 1
        return calendar.dateFromComponents(components)!
    }

}