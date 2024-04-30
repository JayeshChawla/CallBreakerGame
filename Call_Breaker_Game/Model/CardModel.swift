//
//  CardModel.swift
//  ThreeCards_Poker
//
//  Created by MACPC on 08/04/24.
//

import UIKit

class CardModel: NSObject {

    let suit : CardSuit
    let rank : CardRank
    var asset : String{
        get{ return suit.rawValue + rank.strValue()}
    }
    
    init(suit : CardSuit , rank : CardRank){
        self.suit = suit
        self.rank = rank
        super.init()
    }
    func compareRank(to card : CardModel) -> ComparisonResult{
        let selfRankValue = self.rank.rawValue
        let cardRankValue = card.rank.rawValue
        
        if selfRankValue == cardRankValue{
            return self.suit.rawValue < card.suit.rawValue ? .orderedAscending : .orderedDescending
        } else{
            return selfRankValue < cardRankValue ? .orderedAscending : .orderedDescending
        }
    }
}
