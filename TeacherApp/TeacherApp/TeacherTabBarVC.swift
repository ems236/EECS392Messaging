//
//  TeacherTabBarVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 5/2/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class TeacherTabBarVC: UITabBarController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Preload all tabs
        if let viewControllers = self.viewControllers
        {
            for viewController in viewControllers
            {
                let _ = viewController.view
            }
        }
    }
}
