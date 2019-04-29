//
//  QuizDescriptionContentView.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

// Referenced code from https://www.youtube.com/watch?v=r5SKUXSuDOw

class ContentTemplate: UIView {
    
    var view: UIView!
    var nibName: String!
    
    override required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func TemplateNibName() -> String { fatalError("Must Override") }
    
    private func setup() {
        self.nibName = TemplateNibName()
        
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

class QuizContentTemplate: ContentTemplate {
    @IBOutlet weak var descriptionText: UITextView!
    
    override func TemplateNibName() -> String {
        return "QuizContentTemplate"
    }
}

class QuestionContentTemplate: ContentTemplate { }

class QuestionShortAnswerTemplate: QuestionContentTemplate {
    
    override func TemplateNibName() -> String {
        return "QuestionShortAnswerTemplate"
    }
}

class QuestionMultipleChoiceTemplate: QuestionContentTemplate {
    
    override func TemplateNibName() -> String {
        return "QuestionMultipleChoiceTemplate"
    }
}
