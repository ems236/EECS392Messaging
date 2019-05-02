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
    static let instance = MultiPeerDriver()
    
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
        print(session.connectedPeers)
        return session
    }()
    
    func connectToPeer(_ peer: MCPeerID)
    {
        teacherPeerId = peer
        serviceBrowser.invitePeer(peer, to: session, withContext: nil, timeout: 10)
        print("Attempting to connect to peer")
    }
    
    func postQuestion(_ question: TeacherQuestion) -> Bool
    {
        if let questionData = messageCoder.encodeMessage(question, type: .question)
        {
            return sendDataGenericError(data: questionData)
        }
        else
        {
            print("Failed to Encode")
            return false
        }
    }
    
    func postDiscussionMessage(_ message: DiscussionPost) -> Bool
    {
        if let messageData = messageCoder.encodeMessage(message, type: .message)
        {
            return sendDataGenericError(data: messageData)
        }
        else
        {
            print("Failed to Encode")
            return false
        }
    }
    
    private func sendDataGenericError(data: Data) -> Bool
    {
        if let teacherPeer = teacherPeerId
        {
            do
            {
                try session.send(data, toPeers: [teacherPeer], with: .reliable)
            }
            catch
            {
                print("Failed to send")
                return false
            }
            return true
        }
        return false
            
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
        NotificationCenter.default.post(name: .discoveredTeacher, object: nil, userInfo: [NotificationUserData.peerChange.rawValue: peerID])
        print("discovered teacher")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID)
    {
        var peerInfo = [String : MCPeerID]()
        peerInfo["peer"] = peerID
        NotificationCenter.default.post(name: .lostTeacher, object: nil, userInfo: [NotificationUserData.peerChange.rawValue: peerID])
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
                print("Posting notification for teacher disconnect")
                NotificationCenter.default.post(name: .teacherDisconnect, object: nil)
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
            messageCoder.decodeMessage(data, peer: peerID)
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
    func forwardData(_ data: Data, exclude: MCPeerID)
    {
        //Student Doesnt do this
        return
    }
    
    func receiveQuiz(_ quiz: Quiz)
    {
        NotificationCenter.default.post(name: .quizReceived, object: nil, userInfo: [NotificationUserData.quizReceived.rawValue : quiz])
    }
    
    func receiveDiscussionPost(_ message: DiscussionPost)
    {
        NotificationCenter.default.post(name: .messageReceived, object: nil, userInfo: [NotificationUserData.messageReceived.rawValue: message])
    }
    
    func receiveAnswers(_ answers: StudentAnswer) {
        //Student doesn't do this.
        return
    }
    
    func receiveQuestionPost(_ question: TeacherQuestion) {
        //Student doesn't do this.
        return
    }
}
