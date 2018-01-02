//
//  Entities.swift
//  Billowner
//
//  Created by SMS Simple Mobile Solutions on 4/11/16.
//  Copyright © 2016 Billowner. All rights reserved.
//

import Foundation

//
//  Constants.swift
//  GuiachatSwift
//
//  Created by SMS Simple Mobile Solutions on 12/07/16.
//  Copyright © 2016 JulianDev. All rights reserved.
//

import UIKit

struct Entities {
    
    struct Question {
        static let questionID = "questionID"
        static let text = "text"
    }
    
    struct Response {
        static let responseID = "responseID"
        static let questionID = "questionID"
        static let date = "date"
        static let deviceID = "deviceID"
        static let value = "value"
        
    }
    
    struct Device {
        static let deviceID = "deviceID"
        static let questionID = "questionID"
        static let name = "name"
    }
    
}
