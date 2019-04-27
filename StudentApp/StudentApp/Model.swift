//
//  Model.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

class ConnectionData {
    private static let SHARED_INSTANCE = ConnectionData()
    static func instance() -> ConnectionData { return SHARED_INSTANCE }
    
    private var isLive: Bool
    private var currentSlide: Int
    private var _teacherSlide: Int
    private var teacherSlide: Int {
        get { return _teacherSlide }
        set {
            _teacherSlide = newValue
            if isLive { currentSlide = _teacherSlide }
        }
    }
    var displayedSlide: Int { get { return isLive ? teacherSlide : currentSlide } }
    
    /* private var connection: SessionToTeacher? <-- Don't know what this should look like */
    
    private init () { _teacherSlide = 0; currentSlide = 0; isLive = true }
}
