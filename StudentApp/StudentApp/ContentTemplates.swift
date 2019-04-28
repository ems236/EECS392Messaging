//
//  QuizDescriptionContentView.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

// Referenced code from https://www.youtube.com/watch?v=r5SKUXSuDOw
class QuizContentTemplate: UIView {
    
    var view: UIView!
    var nibName: String = "QuizContentTemplate"
    @IBOutlet weak var descriptionText: UITextView!
    
    override init(frame: CGRect) {
        // Properties
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // Properties
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        view = loadViewFromNib()
        
        view.frame = self.bounds
        view.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.flexibleWidth.rawValue | UIView.AutoresizingMask.flexibleHeight.rawValue)
        
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
