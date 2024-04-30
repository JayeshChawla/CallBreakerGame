//
//  Card.swift
//  Call_Breaker_Game
//
//  Created by MACPC on 24/04/24.
//

import Foundation
import SpriteKit

class Card: SKSpriteNode {
    // Properties to represent the card
    var suit: CardSuit
    var rank: CardRank
    let sprite: SKSpriteNode
    var isFaceUp: Bool = false

    // Initializer to create a card with a given texture
    init(texture: SKTexture, suit: CardSuit, rank: CardRank, sprite : SKSpriteNode) {
        self.suit = suit
        self.rank = rank
        self.sprite = sprite
        super.init(texture: texture, color: .clear, size: texture.size())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func getSuitFromCard(_ card: Card) -> CardSuit {
        return card.suit
    }
}

