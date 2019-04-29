//
//  AvailableRoomsTableVC.swift
//  StudentApp
//
//  Created by Ellis Saupe on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class AvailableRoomsTableVC: UITableViewController {

    private let driver = MultiPeerDriver.multipeerdriver
    private var availableRooms = [MCPeerID]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    @objc func foundRoom(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: MCPeerID]
        {
            if let peer = data["peer"]
            {
                availableRooms.append(peer)
                tableView.reloadData()
                //Refresh table data
            }
            else
            {
                print("Invalid data")
            }
        }
        
        else
        {
            print("No data")
        }
    }
    
    @objc func lostRoom(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: MCPeerID]
        {
            if let peer = data["peer"], let index = availableRooms.lastIndex(of: peer)
            {
                availableRooms.remove(at: index)
                tableView.reloadData()
                //Refresh table
            }
            else
            {
                print("Invalid data")
            }
        }
            
        else
        {
            print("No data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(foundRoom(_:)), name: .discoveredTeacher, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(lostRoom(_:)), name: .lostTeacher, object: nil)

        print("Encoding/Decoding")
        //var testEncoding = MessageCoder()
        //var testQuiz = Quiz()
        
        //var data = testEncoding.encodeMessage(testQuiz, type: .quiz)?.advanced(by: 1)
        //let jsonString = String(data: data!, encoding: .utf8)
        //print(jsonString)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return availableRooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as? RoomCell
        else
        {
            fatalError("Bad Cell")
        }
        
        let currentRoom = availableRooms[indexPath.row]
        cell.setPeer(currentRoom)
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Show loading probably
        
        let selectedPeer = availableRooms[indexPath.row]
        MultiPeerDriver.multipeerdriver.connectToPeer(selectedPeer)
        
        self.performSegue(withIdentifier: "JoinRoom", sender: selectedPeer)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}