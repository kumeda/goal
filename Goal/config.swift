//
//  config.swift
//  Goal
//
//  Created by kazuhiko umeda on 2015/12/08.
//  Copyright © 2015年 k.umeda. All rights reserved.
//

import UIKit
import RealmSwift

struct ColorConfig {
    static let GOAL_WHITE = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
    static let GOAL_PINK = UIColor(red:0.98, green:0.36, blue:0.34, alpha:1.0)
    static let GOAL_NAVY = UIColor(red:0.13, green:0.25, blue:0.36, alpha:1.0)
    static let GOAL_DUST = UIColor(red:0.80, green:0.65, blue:0.55, alpha:1.0)
    static let GOAL_GRAY = UIColor(red:0.70, green:0.69, blue:0.71, alpha:1.0)
    static let GOAL_LIGHT_GRAY = UIColor(red:0.82, green:0.82, blue:0.84, alpha:1.0)
}

struct FontConfig {
    static let GOAL_LARGE = UIFont(name: "Avenir Next", size: CGFloat(24))
    static let GOAL_NORMAL = UIFont(name: "Avenir Next", size: CGFloat(20))
    static let GOAL_SMALL = UIFont(name: "Avenir Next", size: CGFloat(18))
    static let GOAL_EX_SMALL = UIFont(name: "Avenir Next", size: CGFloat(12))
}

struct GoalStatusConfig {
    static let PROGRESS = 1
    static let COMPLETE = 2
    static let GIVEUP = 3
    static let DELETED = 4
}

let RealmConfig = Realm.Configuration(
    schemaVersion: 8,
    migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 8) {
        }
})
let realm = try! Realm(configuration: RealmConfig)


