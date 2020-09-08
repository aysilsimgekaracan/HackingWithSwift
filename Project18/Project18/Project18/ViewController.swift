//
//  ViewController.swift
//  Project18
//
//  Created by Ayşıl Simge Karacan on 7.09.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("I'm inside the viewDidLoad() method.")
//        print(1, 2, 3, 4 ,5, separator: "-") // separator, lets you provide a string that should be placed between every item in the print() call.
//        print("Some message", terminator: "") // terminator, is what should be placed after the final item. It’s \n by default, which you should remember means “line break”. If you don’t want print() to insert a line break after every call, just write this
//
//        assert(1 == 1, "Math failure!")
//        assert(1 == 2, "Math failure")
        //assert(myReallySlowMethod() == true, "The slow method returned false, which is a bad thing.)
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }


}

