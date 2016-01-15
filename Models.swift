//
//  Models.swift
//  Goals
//
//  Created by kazuhiko umeda on 2015/10/21.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import RealmSwift

class Goal: Object {
    
    var doneDays = List<DoneDay>()
    
    dynamic var id: Int = 0
    dynamic var goalTitle: String? = nil
    dynamic var goalTotalAmount: Int = 0
    dynamic var goalUnit: String? = nil
    dynamic var achieveAmount: Int = 0
    dynamic var achieveDays: Int = 0
    dynamic var achieveRate: Int = 0
    dynamic var taskPerDayAmount: Int = 0
    dynamic var goalStatus: Int = 0
    // 0:intial 1:progress 2:completed 3:giveup 4:deleted

    dynamic var monday: Bool = false
    dynamic var tuesday: Bool = false
    dynamic var wednesday: Bool = false
    dynamic var thursday: Bool = false
    dynamic var friday: Bool = false
    dynamic var saturday: Bool = false
    dynamic var sunday: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /* -- to become interesting, it may be good to add something like status --*/
}

class DoneDay: Object {
    dynamic var goal: Goal?

    dynamic var doneDay: NSDate?
    dynamic var taskAmount: Int = 0
}