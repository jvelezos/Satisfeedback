//
//  SurveyViewController.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 18/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit
import Firebase

class SurveyViewController: UIViewController, OverlayHost {

    var rootToDevices = "devices"
    var rootToQuestions = "questions"
    var refHanlde: UInt!
    var refHanlde2: UInt!
    var ref: FIRDatabaseReference!
    @IBOutlet var questionLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        self.validateName()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onePressed(_ sender: Any) {
        self.faceSelected(value: 1)
    }

    @IBAction func twoPressed(_ sender: Any) {
        self.faceSelected(value: 2)
    }

    @IBAction func threePressed(_ sender: Any) {
        self.faceSelected(value: 3)
    }
    
    func faceSelected(value:Int){
        let defaults = UserDefaults.standard
        let questionID = defaults.string(forKey: "questionID")
        if(questionID != "" && questionID != nil ){
            self.addResponse(value: value, questionID: questionID!)
            showOverlay(type: ThanksViewController.self, fromStoryboardWithName: "Main")
        }
        
    }
    func addResponse(value: Int, questionID: String){
        FBLayer().saveNewResponse(questionID, value: value)
    }
    
    func validateName(){
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "deviceName")
        if name == nil {
            print("es nulo")
            self.showAlert()
        }else{
            self.listenToQuestionChanges()
        }
        let questionID = defaults.string(forKey: "questionID")
        if questionID != "" && questionID != nil{
            self.listenToActualQuestionChanges(questionID: questionID!)
        }
    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Sin nombre", message: "Dale un nombre al dispositivo", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let defaults = UserDefaults.standard
            FBLayer().logOutDevice()
            defaults.set(textField?.text, forKey: "deviceName")
            FBLayer().logDevice()
            self.listenToQuestionChanges()
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert: alert, animated: true, completion: nil)
    }
    
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
    }
    
    func listenToQuestionChanges(){
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        self.rootToDevices = self.rootToDevices + "/" + deviceID
        self.refHanlde = ref.child(rootToDevices).observe(.childChanged, with: {(snapshot) -> Void in
            if(snapshot.key == "questionID"){
                if self.refHanlde2 != nil{
                    self.removeOldQuestionReference()
                }
                let questionID:String = snapshot.value as! String
                if (questionID != "" ){
                    let defaults = UserDefaults.standard
                    defaults.set(questionID, forKey: "questionID")
                    self.listenToActualQuestionChanges(questionID: questionID)
                }
            }
            
            
        })
    }
    
    func listenToActualQuestionChanges(questionID:String){
        
        print("listening")
        self.refHanlde2 = 0
        self.refHanlde2 = ref.child(rootToQuestions + "/" + questionID + "/text").observe(.value, with: {(snapshot) -> Void in
            if let val = snapshot.value as? String {
                print(val)
                let questionText:String = snapshot.value as! String
                if (questionID != ""){
                    self.questionLbl.text = questionText
                }
                
            }
            
            
        })
    }
    
    func removeOldQuestionReference(){
        let defaults = UserDefaults.standard
        let questionID = defaults.string(forKey: "questionID")
        if(questionID != "" && questionID != nil ){
            let path = self.rootToQuestions + "/" + questionID!
            self.ref.child(path + "/text").removeObserver(withHandle: self.refHanlde2)
        }
    }
    
   
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
