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

class QuestionContentTemplate: ContentTemplate {
    func saveChoices(_ choices: [Answer]) { }
}

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
            self.view.clipsToBounds = false
        }
    }
    
    @IBOutlet weak var ChoiceID: UILabel!
    @IBOutlet weak var ChoiceDescription: UILabel!
    @IBOutlet weak var SelectButton: UIButton!
    
    override func TemplateNibName() -> String {
        return "ChoiceContentTemplate"
    }
    func loadIn(id: String, desc: String) {
        ChoiceID.text = id
        ChoiceDescription.text = desc
        radius = 5
    }
    @IBAction func Select(_ sender: UIButton) {
        self.view.backgroundColor = onColor
        delegate?.hasBeenSelected(self)
    }
    func Deselect() {
        self.view.backgroundColor = offColor
    }
}

protocol ChoiceContentDelegate {
    func hasBeenSelected(_ sender: ChoiceContentTemplate)
}

class QuestionMultipleChoiceTemplate: QuestionContentTemplate, ChoiceContentDelegate {
    
    @IBOutlet weak var descriptionText: UITextView! {
        didSet { descriptionText.clearsOnInsertion = true } }
    @IBOutlet weak var choiceA: ChoiceContentTemplate! {
        didSet { choiceA.delegate = self } }
    @IBOutlet weak var choiceB: ChoiceContentTemplate! {
        didSet { choiceB.delegate = self } }
    @IBOutlet weak var choiceC: ChoiceContentTemplate! {
        didSet { choiceC.delegate = self } }
    @IBOutlet weak var choiceD: ChoiceContentTemplate! {
        didSet { choiceD.delegate = self } }
    
    var answer: String?
    var _question: Question?
    var question: Question? {
        get { return _question }
        set {
            _question = newValue
            loadQuestion()
        }
    }
    
    override func TemplateNibName() -> String {
        return "QuestionMultipleChoiceTemplate"
    }
    
    private func templates() -> [ChoiceContentTemplate] {
        return [choiceA, choiceB, choiceC, choiceD]
    }
    
    private func loadQuestion() {
        let choices = question!.answers
        var i = 0
        for template in templates() {
            if i < choices.count {
                template.isHidden = false
                template.loadIn(id: i.description, desc: choices[i].text)
                print("found one!")
            } else {
                template.isHidden = true
            }
            i += 1
        }
        descriptionText.insertText(question!.name)
        print("loaded "+templates().count.description+" choice things")
        print(choices.count.description+" of them are answerable")
    }
    
    func hasBeenSelected(_ sender: ChoiceContentTemplate) {
        for template in templates() {
            if template != sender {
                template.Deselect()
            } else {
                answer = template.ChoiceID.text
            }
        }
    }
}
