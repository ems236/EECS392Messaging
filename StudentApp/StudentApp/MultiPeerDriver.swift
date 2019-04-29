//
//  MultiPeerDriver.swift
//  StudentApp
//
//  Created by Ellis Saupe on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultiPeerDriver : NSObject
{
    private override init()
    {
        print("Called init")
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: TEACHERSERVICE)
        
        super.init()
        
        serviceBrowser.delegate = self
        serviceBrowser.startBrowsingForPeers()
        print("Browsing")
    }
    
    deinit {
        serviceBrowser.stopBrowsingForPeers()
    }
    static let multipeerdriver = MultiPeerDriver()
    
    private let DELIMITER = "\\/&"
    private let TEACHERSERVICE = "eecs392-final"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser : MCNearbyServiceBrowser
    
    private var teacherPeerId : MCPeerID? = nil
    
    //Lazy so you don't have to initialize it or make it null
    //student will only ever have 1 session
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    func connectToPeer(_ peer: MCPeerID)
    {
        teacherPeerId = peer
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
        print("Attempting to connect to peer")
    }
}

//SERVICE BROWSER DELEGATE
extension MultiPeerDriver : MCNearbyServiceBrowserDelegate
{
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?)
    {
        //Found teacher
        
        //teacherPeerId = peerID
        //browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
        print("Inviting teacher")
        print("Discovered")
        var peerInfo = [String : MCPeerID]()
        peerInfo["peer"] = peerID
        NotificationCenter.default.post(name: .discoveredTeacher, object: nil, userInfo: peerInfo)
        print("discovered teacher")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        var peerInfo = [String : MCPeerID]()
        peerInfo["peer"] = peerID
        NotificationCenter.default.post(name: .lostTeacher, object: nil, userInfo: peerInfo)
        print("Lost connection to teacher?")
    }
}

extension MultiPeerDriver : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if let teacher = teacherPeerId, peerID == teacher
        {
            if state == .connected
            {
                serviceBrowser.stopBrowsingForPeers()
                print("Stopping browsing")
            }
            else if state == .notConnected
            {
                serviceBrowser.startBrowsingForPeers()
                print("Browsing for teacher again")
            }
            //Handle teacher connect here
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // == works intelligently in swift
        if let teacher = teacherPeerId, peerID == teacher
        {
            //Handle message here
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        if let teacher = teacherPeerId, peerID == teacher
        {
            //Handle message here
        }
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        if let teacher = teacherPeerId, peerID == teacher
        {
            //Handle message here
        }
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        if let teacher = teacherPeerId, peerID == teacher
        {
            //Handle message here
        }
    }
}
