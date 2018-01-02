//
//  QuestionViewController.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 11/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit
import Firebase

class QuestionViewController: UIViewController , UITableViewDelegate,  UITableViewDataSource{

    @IBOutlet var detailView: UIView!
    @IBOutlet var resultLbl: UILabel!
    @IBOutlet var peopleLbl: UILabel!
    @IBOutlet var editTextField: UITextField!
    @IBOutlet var questionTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var refHandle2: UInt!
    var rootToList = "questions"
    let cellIdentifier = "QuestionCell"
    var allObjects = [Question]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        self.fetchListContent()
        self.fetchRemovals()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onAddPressed(_ sender: Any) {
        FBLayer().saveNewQuestion(questionTextField.text!)
        self.questionTextField.resignFirstResponder()
        self.questionTextField.text = ""
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allObjects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuestionTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! QuestionTableViewCell
        
        let thisObject = self.allObjects[indexPath.row]
        cell.textLbl?.text = thisObject.text
        cell.parent = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.peopleLbl.text = "0"
        self.resultLbl.text = "0"
        let respManager = ResponsesManager()
        
        let app = UIApplication.shared.delegate as! AppDelegate
        app.selectedQuestionID = allObjects[indexPath.row].questionID!
        respManager.startRecolectionFor(question: app.selectedQuestionID! ,parent: self)
        self.detailView.alpha = 1
        self.editTextField.text = allObjects[indexPath.row].text
        //self.addResponse(value: 1, questionID: self.allObjects[indexPath.row].questionID!)
    }
    
    func fetchListContent(){
        
        self.refHandle = ref.child(rootToList).observe(.childAdded, with: {(snapshot) -> Void in
            if let dict = snapshot.value as? [String: AnyObject]{
                let thisCustomObject = Question()
                thisCustomObject.setValuesForKeys(dict)
                thisCustomObject.questionID = snapshot.key
                self.allObjects.append(thisCustomObject)
                self.tableView.reloadData()
            }
            
        })
    }
    func fetchRemovals(){
        self.refHandle2 = ref.child(rootToList).observe(.childRemoved, with: {(snapshot) -> Void in
            self.ref.child(self.rootToList).removeObserver(withHandle: self.refHandle)
            self.allObjects = [Question]()
            self.detailView.alpha = 0
            self.fetchListContent()
        })
        
    }
    

    @IBAction func onDeleteQuestionPressed(_ sender: Any) {
        self.presentAlert()
    }

    @IBAction func onEditBtnPressed(_ sender: Any) {
        let app = UIApplication.shared.delegate as! AppDelegate
        self.ref.child(rootToList).child(app.selectedQuestionID!).child("text").setValue(self.editTextField.text)
        
    }
    
    func presentAlert(){
        let alertController = UIAlertController(title: "Borrar?", message: "Desea borrar esta pregunta junto con sus datos", preferredStyle: .alert)
        
        // Create the actions
        let okAction = UIAlertAction(title: "Borrar", style: UIAlertActionStyle.default) {
            UIAlertAction in
            NSLog("OK Pressed")
            let app = UIApplication.shared.delegate as! AppDelegate
            self.ref.child(self.rootToList).child(app.selectedQuestionID!).removeValue()
            self.ref.child("responses").child(app.selectedQuestionID!).removeValue()
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alert: alertController, animated: true, completion: nil)
    }
    
    private func presentViewController(alert: UIAlertController, animated flag: Bool, completion: (() -> Void)?) -> Void {
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: flag, completion: completion)
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
