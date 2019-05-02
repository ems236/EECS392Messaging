//
//  MultiPeerDriver.swift
//  TeacherApp
//
//  Created by Ellis Saupe on 4/27/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultiPeerDriver : NSObject
{
    static let instance = MultiPeerDriver()
    
    private let SESSIONMAX = 8
    
    private let TEACHERSERVICE = "eecs392-final"
    private let myPeerID : MCPeerID
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    
    private var connectedSessions = [MCSession]()
    private let messagecoder = MessageCoder()
    
    //These will be sent a quiz if one is posted
    private var newPeers = [MCPeerID]()
    private var currentQuiz: Data? = nil
    
    private override init()
    {
        var displayname = "Teacher"
        if let name = UserDefaults.standard.object(forKey: "DisplayName") as? String
        {
            displayname = name
        }
        myPeerID = MCPeerID(displayName: displayname)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: TEACHERSERVICE)
        
        super.init()
        
        messagecoder.delegate = self
        
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        print("Advertising")
    }
    
    private func findEmptySession() -> MCSession
    {
        for session in connectedSessions
        {
            if session.connectedPeers.count < SESSIONMAX
            {
                return session
            }
        }
        
        let newSession = makeSession()
        connectedSessions.append(newSession)
        return newSession
    }
    
    private func makeSession() -> MCSession
    {
        let newSession = MCSession(peer: self.myPeerID, securityIdentity: nil, encryptionPreference: .required)
        newSession.delegate = self
        return newSession
    }
    
    func getConnectedPeers() -> [MCPeerID]
    {
        var peers = [MCPeerID]()
        for session in connectedSessions
        {
            peers.append(contentsOf: session.connectedPeers)
        }
        return peers
    }
    
    private func sendDataGenericError(session: MCSession, data: Data, peers: [MCPeerID]) -> Bool
    {
        do
        {
            try session.send(data, toPeers: peers, with: .reliable)
        }
        catch
        {
            //Make a UI alert or something
            print("Failed to send message")
            return false
        }
        return true
    }
    
    private func broadcastData(data: Data, excluding: MCPeerID? = nil) -> Bool
    {
        print("In broadcast")
        for session in connectedSessions
        {
            let peers = getSessionPeersExcluding(session: session, excluding: excluding)
            print("In broadcast session")
            if peers.count > 0 && !sendDataGenericError(session: session, data: data, peers: peers)
            {
                return false
            }
        }
        return true
    }
    
    private func getSessionPeersExcluding(session: MCSession, excluding: MCPeerID?) -> [MCPeerID]
    {
        if let unwrappedExclude = excluding, session.connectedPeers.contains(unwrappedExclude)
        {
            return session.connectedPeers.filter({$0 != unwrappedExclude})
        }
        else
        {
            return session.connectedPeers
        }
    }
    
    func postQuiz(_ quiz: Quiz) -> Bool
    {
        if let encodedQuiz = messagecoder.encodeMessage(quiz, type: .quiz)
        {
            print("posting quiz")
            //Give up on everything on an error
            if !broadcastData(data: encodedQuiz)
            {
                print("failed to post quiz")
                return false
            }
            print("posted quiz")
            //Reset new peers and current quiz
            newPeers = [MCPeerID]()
            currentQuiz = encodedQuiz
            return true
        }
        else
        {
            //Make a UI alert or something
            print("Failed to encode quiz")
            return false
        }
    }
    
    func resetQuiz()
    {
        currentQuiz = nil
    }
    
    func postDiscussionMessage(_ message: DiscussionPost) -> Bool
    {
        if let encodedMessage = messagecoder.encodeMessage(message, type: .message)
        {
            //Give up on everything on an error
            if !broadcastData(data: encodedMessage)
            {
                print("Failed to send message")
                return false
            }
            return true
        }
        else
        {
            //Make a UI alert or something
            print("Failed to encode message")
            return false
        }
    }
    
    /*
    func findSessionWithPeer(_ peer: MCPeerID) -> MCSession?
    {
        for session in connectedSessions
        {
            if session.connectedPeers.contains(peer)
            {
                return session
            }
        }
        return nil
    }*/
}

extension MultiPeerDriver : MCNearbyServiceAdvertiserDelegate
{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //Should be a little smarter and fill the sessions array
        invitationHandler(true, findEmptySession())
        newPeers.append(peerID)
        print("Invited")
    }
}

extension MultiPeerDriver : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        //Send quiz to newly connected peer if possible
        if state == .connected
        {
            print("Connected")
            NotificationCenter.default.post(name: .studentJoined, object: nil, userInfo: [NotificationUserData.peerChange.rawValue: peerID])
            if let peerIndex = newPeers.firstIndex(of: peerID), let quizData = currentQuiz
            {
                newPeers.remove(at: peerIndex)
                //Don't need to do anything with the status bool
                let _ = sendDataGenericError(session: session, data: quizData, peers: [peerID])
            }
        }
        
        if state == .notConnected
        {
            print("Disconnected")
            NotificationCenter.default.post(name: .studentDisconnect, object: nil)
            if session.connectedPeers.count == 0, let sessionIndex = connectedSessions.firstIndex(of: session)
            {
                connectedSessions.remove(at: sessionIndex)
                print("Removing empty session")
            }
        }
        print("State changed")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        messagecoder.decodeMessage(data, peer: peerID)
        print("data received")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("Stream received")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("Resource received")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("Resource finished")
    }
}

extension MultiPeerDriver : MessegeReceiverDelegate
{
    func forwardData(_ data: Data, exclude: MCPeerID)
    {
        let _ = broadcastData(data: data, excluding: exclude)
    }
    
    func receiveDiscussionPost(_ message: DiscussionPost)
    {
        NotificationCenter.default.post(name: .messageReceived, object: nil, userInfo: [NotificationUserData.messageReceived.rawValue: message])
        return
    }
    
    func receiveAnswers(_ answers: StudentAnswer)
    {
        NotificationCenter.default.post(name: .answerSubmitted, object: nil, userInfo: [NotificationUserData.answersReceived.rawValue: answers])
        return
    }
    
    func receiveQuestionPost(_ question: TeacherQuestion)
    {
        NotificationCenter.default.post(name: .questionPosted , object: nil, userInfo: [NotificationUserData.questionPosted.rawValue: question])
        return
    }
    
    func receiveQuiz(_ quiz: Quiz) {
        //Teacher does not do this.
        return
    }
}
