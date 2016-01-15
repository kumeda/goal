//
//  MonthHeaderView.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/13.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import Foundation

class MonthHeaderView: UIView {
    
    var goalId:Int!
    var weekdayView:UIView!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame:CGRect, year:Int, month:Int, goalId:Int){
        super.init(frame: frame)
        
        self.goalId = goalId
        self.setHeader(year,month:month)
    }
    
    func setHeader(year:Int,month:Int){
        
        let subViews:[UIView] = self.subviews as [UIView]
        for view in subViews {
            if view.isKindOfClass(UIView) {
                view.removeFromSuperview()
            }
        }
        let weekdayWidth = Int( frame.size.width / 7.0 )
        let weekdayHeight = Int( frame.size.height )
        
        let goal = realm.objects(Goal).filter("id = \(goalId)").first
        for var i:Int = 0; i < 7;i++ {
            let x:Int       = (i * (weekdayWidth));
            let y:Int       = 0
            let frame:CGRect = CGRectMake(CGFloat(x),
                CGFloat(y),
                CGFloat(weekdayWidth),
                CGFloat(weekdayHeight)
            );
            let dayView:UIView = UIView(frame: frame)
            
            switch i {
            case 0:
                if goal!.monday {
                    addImageView("Week_M_on.pdf", dayView: dayView)
                } else {
                    addImageView("Week_M_on.pdf", dayView: dayView)
                }
            case 1:
                if goal!.tuesday{
                    addImageView("Week_T_off.pdf", dayView: dayView)
                } else {
                    addImageView("Week_T_on.pdf", dayView: dayView)
                }
            case 2:
                if goal!.wednesday {
                    addImageView("Week_W_off.pdf", dayView: dayView)
                } else {
                    addImageView("Week_W_on.pdf", dayView: dayView)
                }
            case 3:
                if goal!.thursday {
                    addImageView("Week_T_off.pdf", dayView: dayView)
                } else {
                    addImageView("Week_T_on.pdf", dayView: dayView)
                }
            case 4:
                if goal!.friday {
                    addImageView("Week_F_off.pdf", dayView: dayView)
                } else {
                    addImageView("Week_F_on.pdf", dayView: dayView)
                }
            case 5:
                if goal!.saturday {
                    addImageView("Week_S_off.pdf", dayView: dayView)
                } else {
                    addImageView("Week_S_on.pdf", dayView: dayView)
                }
            case 6:
                if goal!.sunday {
                    addImageView("Week_S_off.pdf", dayView: dayView)
                } else {
                    addImageView("Week_S_on.pdf", dayView: dayView)
                }
            default:
                print("test")
            }
        }
    }
    
    func addImageView(imageTitle: String?, dayView: UIView) {
        let image:UIImage? = UIImage(named:imageTitle!)
        let imageView = UIImageView(image:image)
        let size = dayView.frame.height
        let x = (dayView.frame.width - size) / 2.0
        imageView.frame = CGRectMake(x,0,size,size)
        dayView.addSubview(imageView)
        self.addSubview(dayView)
    }
    
}