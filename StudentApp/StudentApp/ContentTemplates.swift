//
//  QuizDescriptionContentView.swift
//  StudentApp
//
//  Created by Jackson Nelson-Gal on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

// Referenced code from https://www.youtube.com/watch?v=r5SKUXSuDOw

@IBDesignable class ContentTemplate: UIView {
    
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

class ChoiceContentTemplate: ContentTemplate {
    
    @IBInspectable var offColor: UIColor?
    @IBInspectable var onColor: UIColor?
    
    var delegate: ChoiceContentDelegate?
    
    var radius: CGFloat {
        get { return self.view.layer.cornerRadius }
        set {
            self.view.layer.cornerRadius = newValue
            self.view.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var ChoiceID: UILabel!
    @IBOutlet weak var ChoiceDescription: UILabel!
    @IBOutlet weak var SelectButton: UIButton!
    
    override func TemplateNibName() -> String {
        return "ChoiceContentTemplate"
    }
    func loadIn(id: String, desc: String, isEnabled: Bool) {
        ChoiceID.text = id
        ChoiceDescription.text = desc
        SelectButton.isEnabled = isEnabled
        radius = 5
    }
    @IBAction func Select(_ sender: UIButton) {
        self.backgroundColor = onColor
        delegate?.hasBeenSelected(self)
    }
    func Deselect() {
        self.backgroundColor = offColor
    }
}

protocol ChoiceContentDelegate {
    func hasBeenSelected(_ sender: ChoiceContentTemplate)
}

class QuestionMultipleChoiceTemplate: QuestionContentTemplate, ChoiceContentDelegate {
    
    @IBOutlet weak var choiceA: ChoiceContentTemplate! {
        didSet { choiceA.delegate = self } }
    @IBOutlet weak var choiceB: ChoiceContentTemplate! {
        didSet { choiceB.delegate = self } }
    @IBOutlet weak var choiceC: ChoiceContentTemplate! {
        didSet { choiceC.delegate = self } }
    @IBOutlet weak var choiceD: ChoiceContentTemplate! {
        didSet { choiceD.delegate = self } }
    
    override func TemplateNibName() -> String {
        return "QuestionMultipleChoiceTemplate"
    }
    
    private func Templates() -> [ChoiceContentTemplate] {
        return [choiceA, choiceB, choiceC, choiceD]
    }
    
    func loadChoices(_ choices: [(desc: String, isEnabled: Bool)]) {
        var i = 0
        for template in Templates() {
            if i < choices.count {
                template.loadIn(id: i.description, desc: choices[i].desc, isEnabled: choices[i].isEnabled)
            } else {
                template.loadIn(id: "?", desc: "", isEnabled: false)
            }
            i += 1
        }
    }
    
    func hasBeenSelected(_ sender: ChoiceContentTemplate) {
        for template in Templates() {
            if template != sender {
                template.Deselect()
            }
        }
    }
}
