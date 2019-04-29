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
        
        messageCoder.delegate = self
        print("Browsing")
    }
    
    deinit {
        serviceBrowser.stopBrowsingForPeers()
    }
    static let multipeerdriver = MultiPeerDriver()
    
    private let TEACHERSERVICE = "eecs392-final"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceBrowser : MCNearbyServiceBrowser
    private let messageCoder = MessageCoder()
    
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
    
    class TempQuestion : Codable
    {
        var text : String
        init(_ text : String)
        {
            self.text = text;
        }
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
        teacherPeerId = nil
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

extension MultiPeerDriver : MessegeReceiverDelegate
{
    func receiveQuiz(_ quiz: Quiz) {
        NotificationCenter.default.post(name: .quizReceived, object: nil, userInfo: nil)
    }
    
    func receiveDiscussionPost(_ message: Any) {
        NotificationCenter.default.post(name: .messageReceived, object: nil, userInfo: nil)
    }
    
    func receiveAnswers(_ answers: Answer) {
        //Student doesn't do this.
        return
    }
    
    func receiveQuestionPost(_ question: Any) {
        //Student doesn't do this.
        return
    }
}
