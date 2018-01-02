//
//  DevicesViewController.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 20/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit
import Firebase

class DevicesViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var ref: FIRDatabaseReference!
    var refHandle: UInt!
    var refHandle2: UInt!
    var rootToList = "devices"
    let cellIdentifier = "deviceCell"
    var allObjects = [Device]()
    
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
    

    @IBAction func onBackPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allObjects.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DeviceTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! DeviceTableViewCell
        
        let thisObject = self.allObjects[indexPath.row]
        cell.nameLbl?.text = thisObject.name
        cell.parent = self
        cell.index = indexPath.row
        let app = UIApplication.shared.delegate as! AppDelegate
        if(thisObject.questionID == app.selectedQuestionID){
            cell.switch.setOn(true, animated: true)
        }else{
            cell.switch.setOn(false, animated: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func fetchListContent(){
        
        self.refHandle = ref.child(rootToList).observe(.childAdded, with: {(snapshot) -> Void in
            if let dict = snapshot.value as? [String: AnyObject]{
                let thisdevice = Device()
                thisdevice.setValuesForKeys(dict)
                thisdevice.deviceID = snapshot.key
                thisdevice.change = false
                self.allObjects.append(thisdevice)
                
                self.tableView.reloadData()
            }
            
        })
        
        
    }
    
    func fetchRemovals(){
        self.refHandle2 = ref.child(rootToList).observe(.childRemoved, with: {(snapshot) -> Void in
            self.ref.child(self.rootToList).removeObserver(withHandle: self.refHandle)
            self.allObjects = [Device]()
            self.fetchListContent()
        })
        
    }
    
    func pressedSwitch(index: Int, value: Int){
        let app = UIApplication.shared.delegate as! AppDelegate
        let selectedDevice = allObjects[index]
        if(selectedDevice.questionID == app.selectedQuestionID){
            if(value == 1){
                selectedDevice.change = false
            }else{
                selectedDevice.change = true
            }
        }else{
            if(value == 1){
                selectedDevice.change = true
            }else{
                //do nothing
            }
            
        }

        
    }
    

    @IBAction func onSaveChangesPressed(_ sender: Any) {
        let app = UIApplication.shared.delegate as! AppDelegate
        for dev in allObjects {
            if(dev.change)!{
                if(dev.questionID == app.selectedQuestionID){
                    self.ref.child(rootToList).child(dev.deviceID!).child(Entities.Device.questionID).setValue("")
                }else{
                    self.ref.child(rootToList).child(dev.deviceID!).child(Entities.Device.questionID).setValue(app.selectedQuestionID)
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
