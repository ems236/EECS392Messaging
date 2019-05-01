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
    private let myPeerID = MCPeerID(displayName: "teacher")
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    
    private var connectedSessions = [MCSession]()
    private let messagecoder = MessageCoder()
    
    //These will be sent a quiz if one is posted
    private var newPeers = [MCPeerID]()
    private var currentQuiz: Data? = nil
    
    private override init()
    {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: TEACHERSERVICE)
        super.init()
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
    
    private func broadcastData(data: Data) -> Bool
    {
        for session in connectedSessions
        {
            if !sendDataGenericError(session: session, data: data, peers: session.connectedPeers)
            {
                return false
            }
        }
        return true
    }
    
    func postQuiz(_ quiz: Quiz) -> Bool
    {
        if let encodedQuiz = messagecoder.encodeMessage(quiz, type: .quiz)
        {
            //Give up on everything on an error
            if !broadcastData(data: encodedQuiz)
            {
                return false
            }
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
        NotificationCenter.default.post(name: .studentJoined, object: nil, userInfo: ["peer": peerID])
        print("Connected")
    }
}

extension MultiPeerDriver : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        //Send quiz to newly connected peer if possible
        if state == .connected, let peerIndex = newPeers.firstIndex(of: peerID), let quizData = currentQuiz
        {
            newPeers.remove(at: peerIndex)
            //Don't need to do anything with the status bool
            sendDataGenericError(session: session, data: quizData, peers: [peerID])
        }
        print("State changed")
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("Message received")
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
    func receiveDiscussionPost(_ message: DiscussionPost) {
    }
    
    func receiveAnswers(_ answers: StudentAnswer)
    {
        return
    }
    
    func receiveQuestionPost(_ question: TeacherQuestion) {
        return
    }
    
    func receiveQuiz(_ quiz: Quiz) {
        //Teacher does not do this.
        return
    }
}
