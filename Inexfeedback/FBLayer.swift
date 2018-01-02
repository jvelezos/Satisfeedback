//
//  FBConnection.swift
//  Billowner
//
//  Created by SMS Simple Mobile Solutions on 4/11/16.
//  Copyright © 2016 Billowner. All rights reserved.
//

import UIKit
import Foundation
import Firebase


@objc class FBLayer: NSObject {
    
    var ref: FIRDatabaseReference!
    var rootToQuestions = "questions"
    var rootToResponses = "responses"
    var rootToDevices = "devices"
    private var _refHandle: FIRDatabaseHandle!
    
    
    func saveNewQuestion(_ text:String) {
        self.ref = FIRDatabase.database().reference()
        let question = [
            Entities.Question.text: text
            ] as [String : Any]
        self.ref.child(rootToQuestions).childByAutoId().setValue(question)
    }
    
    func saveNewResponse(_ questionID:String, value:Int) {
        self.ref = FIRDatabase.database().reference()
        let nowDouble = NSDate().timeIntervalSince1970
        let date = Int64(nowDouble*1000)
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let response = [
            Entities.Response.questionID:questionID,
            Entities.Response.date: date,
            Entities.Response.value: value,
            Entities.Response.deviceID: deviceID
            ] as [String : Any]
        self.ref.child(rootToResponses).child(questionID).childByAutoId().setValue(response)
    }
    
    func logDevice() {
        self.ref = FIRDatabase.database().reference()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let defaults = UserDefaults.standard
        var name = defaults.string(forKey: "deviceName")
        if name == nil {
            name = deviceID
        }
        var questionID = defaults.object(forKey: "questionID")
        if questionID == nil{
            questionID = ""
        }
        let device = [
            Entities.Device.name: name!,
            Entities.Device.questionID: questionID!
            ] as [String : Any]
        self.ref.child(rootToDevices).child(deviceID).setValue(device)
    }
    
    func logOutDevice() {
        self.ref = FIRDatabase.database().reference()
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        self.ref.child(rootToDevices).child(deviceID).removeValue()
    }
    
    func validateName(){
        

    }
    
}
