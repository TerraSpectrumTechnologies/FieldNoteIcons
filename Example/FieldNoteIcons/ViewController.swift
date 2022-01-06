//
//  ViewController.swift
//  FieldNoteIcons
//
//  Created by BreckClone on 01/06/2022.
//  Copyright (c) 2022 BreckClone. All rights reserved.
//

import UIKit
import FieldNoteIcons

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newImage = UIImage(named: "IMG_0343.jpg")
        FieldNoteIcons.FieldNoteIcon(name: "house")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

