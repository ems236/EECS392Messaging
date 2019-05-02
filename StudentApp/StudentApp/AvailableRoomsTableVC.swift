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

    private let driver = MultiPeerDriver.instance
    var availableRooms = [MCPeerID]()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //An unwind segue for when the teacher disconnects
    @IBAction func disconnectedFromTeacher(segue:UIStoryboardSegue) {}
    
    @objc
    func foundRoom(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: MCPeerID]/*, let peer = data[.peerChange]*/
        {
            if let peer = data[NotificationUserData.peerChange.rawValue]
            {
                availableRooms.append(peer)
                DispatchQueue.main.async
                {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc
    func lostRoom(_ notification: Notification)
    {
        if let data = notification.userInfo as? [String: MCPeerID], let peer = data[NotificationUserData.peerChange.rawValue], let index = availableRooms.lastIndex(of: peer)
        {
            availableRooms.remove(at: index)
            DispatchQueue.main.async
            {
                    self.tableView.reloadData()
            }
        }
    }
    
    @objc
    func willResignActive()
    {
        MultiPeerDriver.instance.fullStop()
    }
    
    
    @objc
    func willBecomeActive()
    {
        restartbrowsing()
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(foundRoom(_:)), name: .discoveredTeacher, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(lostRoom(_:)), name: .lostTeacher, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        restartbrowsing()
    }
    
    private func restartbrowsing()
    {
        driver.restartBrowsing()
        availableRooms.removeAll()
        self.tableView.reloadData()
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
        driver.connectToPeer(selectedPeer)
        
        self.performSegue(withIdentifier: "JoinRoom", sender: selectedPeer)
    }

    @IBAction func SettingsBtn(_ sender: Any)
    {
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
