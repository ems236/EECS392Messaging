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
    
    
    func findEmptySession() -> MCSession
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
    
    func makeSession() -> MCSession
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
    
    private override init()
    {
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: TEACHERSERVICE)
        super.init()
        serviceAdvertiser.delegate = self
        serviceAdvertiser.startAdvertisingPeer()
        print("Advertising")
    }
}

extension MultiPeerDriver : MCNearbyServiceAdvertiserDelegate
{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        //Should be a little smarter and fill the sessions array
        invitationHandler(true, findEmptySession())
        NotificationCenter.default.post(name: .studentJoined, object: nil, userInfo: ["peer": peerID])
        print("Connected")
    }
}

extension MultiPeerDriver : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
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
    
    func receiveAnswers(_ answers: Answer) {
        return
    }
    
    func receiveQuestionPost(_ question: TeacherQuestion) {
        return
    }
    
    func receiveQuiz(_ quiz: Quiz) {
        //Teacher does not do this.
        //NotificationCenter.default.post(name: .quizReceived, object: nil, userInfo: nil)
        return
    }
}
