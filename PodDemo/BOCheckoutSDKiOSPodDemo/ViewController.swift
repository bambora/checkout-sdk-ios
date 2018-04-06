//
//  ViewController.swift
//  BOCheckoutSDKiOSPodDemo
//
//  Created by Allan Lie on 18/04/2018.
//  Copyright © 2018 Bambora Online. All rights reserved.
//

import UIKit
import BOCheckoutSDKiOS


class ViewController: UIViewController {

    @IBOutlet weak var checkoutView: BOCheckoutView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        checkoutView.on(eventType: "*", eventHandler: doOnAnyEvent)
        checkoutView.initialize(checkoutToken: "<<INSERT TOKEN>>")
    }

    func doOnAnyEvent(data: BOCheckoutEventData) {
        
        print("EventType: " + data.eventType)
        print("Payload: " + data.payload)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

