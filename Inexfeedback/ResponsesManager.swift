//
//  ResponsesManager.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 20/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit
import Firebase

class ResponsesManager: NSObject{
    //drag table as tableView
    //replace everything that says Custom
    //add following two to view did load
    //self.ref = FIRDatabase.database().reference()
    //self.fetchListContent()
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var rootToList = "responses"
    var allObjects = [Response]()
    var avg: Double = 0
    var people: Int = 0
    var parent: QuestionViewController!
    
    func startRecolectionFor(question:String, parent:QuestionViewController){
        self.parent = parent
        self.ref = FIRDatabase.database().reference()
        avg = 0
        people = 0
        self.fetchListContent(question: question)
        
    }
    
    
    func fetchListContent(question:String){
        
        self.refHandle = ref.child(rootToList+"/"+question).observe(.childAdded, with: {(snapshot) -> Void in
            if let dict = snapshot.value as? [String: AnyObject]{
                let thisresponse = Response()
                thisresponse.setValuesForKeys(dict)
                self.allObjects.append(thisresponse)
                self.people = self.people + 1
                if(self.people == 1 ){
                    self.avg = thisresponse.value as! Double
                }else{
                    self.avg = (self.avg*Double(self.people-1) + Double(thisresponse.value!)) / Double(self.people)
                }
                
                self.parent.peopleLbl.text = String(self.people)
                self.parent.resultLbl.text = String(self.avg)
                
            }
            
        })
    }

}
