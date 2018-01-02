//
//  ThanksViewController.swift
//  Inexfeedback
//
//  Created by SMS Simple Mobile Solutions on 20/07/17.
//  Copyright © 2017 Bankity. All rights reserved.
//

import UIKit

class ThanksViewController: UIViewController, OverlayViewController {

    let overlaySize: CGSize? = CGSize(width: UIScreen.main.bounds.width,
                                      height: UIScreen.main.bounds.height)
    let overlayFrame: CGRect? = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // must be internal or public.
    @objc func update() {
        dismissOverlay()
        // Something cool
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
