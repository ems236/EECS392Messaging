//
//  QuizAnswerTableVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/30/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuizAnswerTableVC: UITableViewController {

    let letters = ["A", "B", "C", "D"]
    var answers = [[QuestionAnswer]]()
    var correctAnswer = -1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int
    {
        // #warning Incomplete implementation, return the number of sections
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return letters[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return answers[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as? QuestionAnswerCell
            else
        {
            fatalError("Bad Cell")
        }
        let currentAnswer = answers[indexPath.section][indexPath.row]
        cell.setName(name: currentAnswer.name, isCorrect: currentAnswer.answerIndex == correctAnswer)
        
        return cell
    }
}
