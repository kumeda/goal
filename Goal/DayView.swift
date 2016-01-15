//
//  DayView.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/11.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit

class DayView: UIView {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame:CGRect,year:Int,month:Int,day:Int,type:Int){
        super.init(frame: frame)
        let dayWidth:Int = Int( (UIScreen.mainScreen().bounds.size.width) / 7.0 )
        let dayHeight:CGFloat = 30

        if type == 1 {
            addImageView("Calendar_done.pdf", dayView: self)
        } else if type == 2 {
            addImageView("Calendar_today.pdf", dayView: self)
        }
        
        let dayLabel:UILabel = UILabel(frame: CGRectMake(-6.0, 0, CGFloat(dayWidth),dayHeight))
        dayLabel.textAlignment = NSTextAlignment.Center
        dayLabel.text = String(format:"%02d", day)
        dayLabel.textColor = ColorConfig.GOAL_WHITE
        dayLabel.font = FontConfig.GOAL_SMALL
        self.addSubview(dayLabel)
    }
    
    func addImageView(imageTitle: String?, dayView: UIView) {
        let image:UIImage? = UIImage(named:imageTitle!)
        let imageView = UIImageView(image:image)
        let size = dayView.frame.height
        let x = (dayView.frame.width - size) / 2.0
        imageView.frame = CGRectMake(x,0,size,size)
        dayView.addSubview(imageView)
    }

}
