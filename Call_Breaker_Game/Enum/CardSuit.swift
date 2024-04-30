//
//  CardSuit.swift
//  ThreeCards_Poker
//
//  Created by MACPC on 08/04/24.
//

import Foundation

enum CardSuit : String{
    case cardHearts
    case cardDiamonds
    case cardClubs
    case cardSpades
    
    static let allValues : [CardSuit] =  [.cardHearts , .cardDiamonds , .cardClubs , .cardSpades]
    
    static func < (lhs: CardSuit, rhs: CardSuit) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
}

