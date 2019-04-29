//
//  MessegeCoder.swift
//  StudentApp
//
//  Created by Ellis Saupe on 4/28/19.
//  Copyright © 2019 Jackson Nelson-Gal + Ellis Saupe. All rights reserved.
//

import Foundation

enum MessageTypes: UInt8
{
    case error = 0
    case quiz = 1
    case answers = 2
    case question = 3
    case message = 4
}

class MessageCoder
{
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()
    static func encodeMessage<T : Encodable>(_ object: T, type: MessageTypes) -> Data?
    {
        let jsonMaybe = try? encoder.encode(object)
        if let json = jsonMaybe
        {
            var data = uint8ToData(type.rawValue)
            data.append(json)
            return data
        }
        return nil
    }

    static func decodeMessage(_ message: Data)
    {
        //read fist byte
        guard let typeEnum = MessageTypes(rawValue: [UInt8](message).first ?? 0)
            else
        {
            return
        }
        
        switch typeEnum {
        case .message:
            print("received message")
        case .quiz:
            print("received quiz")
        default:
            return
        }
    }

    static func uint8ToData(_ value: UInt8) -> Data
    {
        var copy = value
        return Data(bytes: &copy, count: MemoryLayout.size(ofValue: copy))
    }
}
