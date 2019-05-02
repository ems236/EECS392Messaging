//
//  QuestionsTableVC.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/29/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit

class QuestionsTableVC: UITableViewController {

    //var questions = [TeacherQuestion]()
    var questions = [TeacherQuestion.testQuestion(), TeacherQuestion.testQuestion(), TeacherQuestion.testQuestion()]
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier
        {
            switch id
            {
            case "ShowQuestion":
                let PostVC = segue.destination as! QuestionPostVC
                PostVC.question = sender as! TeacherQuestion
            default: break
            }
        }
    }
    
    //Create a segue for the save btn
    @IBAction func deleteQuestionUnwind(segue:UIStoryboardSegue) {}
    
    @objc
    func questionPosted(_ notification: Notification)
    {
        if let dict = notification.userInfo as? [String : TeacherQuestion], let question = dict[NotificationUserData.questionPosted.rawValue]
        {
            
            questions.append(question)
            DispatchQueue.main.async
            {
                self.tableView.reloadData()
            }
        }
    }
    
    func deleteQuestion(_ question: TeacherQuestion)
    {
        if let index = questions.lastIndex(of: question)
        {
            questions.remove(at: index)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(questionPosted(_:)), name: .questionPosted, object: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowQuestion", sender: questions[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as? QuestionPostCell
        else
        {
            fatalError("Bad Cell")
        }
        
        cell.setQuestion(questions[indexPath.row])
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    */

}
