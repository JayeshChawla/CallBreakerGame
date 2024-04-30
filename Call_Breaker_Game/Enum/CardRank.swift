//
//  CardRank.swift
//  ThreeCards_Poker
//
//  Created by MACPC on 08/04/24.
//

import Foundation
import QuartzCore

enum CardRank : Int{
    case Ace = 1
    case Two , Three , Four , Five , Six , Seven , Eight , Nine , Ten
    case Jack
    case Queen
    case King
    
    func strValue() -> String{
        switch self{
        case .Ace : return "A"
        case .King : return "K"
        case .Queen : return "Q"
        case .Jack : return "J"
        default : return "\(rawValue)"
        }
    }
    
    
    static let allValue : [CardRank] = [.Two , .Three , .Four , .Five , .Six , .Seven , .Eight , .Nine , .Ten , .Jack , .Queen , .King , .Ace ]
}
extension CardRank: Comparable {
    static func < (lhs: CardRank, rhs: CardRank) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
