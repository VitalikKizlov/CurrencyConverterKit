//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import Foundation

public struct ExchangeData {
    public var sender: SenderDataItem
    public var receiver: ReceiverDataItem

    public init(sender: SenderDataItem, receiver: ReceiverDataItem) {
        self.sender = sender
        self.receiver = receiver
    }

    mutating public func swap() {
        let temporarySender = sender

        sender.country = receiver.country
        sender.amount = receiver.amount

        receiver.country = temporarySender.country
        receiver.amount = temporarySender.amount
    }

    mutating public func changeSenderAmount(_ amount: Double) {
        sender.amount = amount
    }

    mutating public func changeReceiverAmount(_ amount: Double) {
        receiver.amount = amount
    }
}

public struct SenderDataItem {
    public var country: Country
    public var amount: Double

    public init(country: Country, amount: Double) {
        self.country = country
        self.amount = amount
    }
}

public struct ReceiverDataItem {
    public var country: Country
    public var amount: Double

    public init(country: Country, amount: Double) {
        self.country = country
        self.amount = amount
    }
}
