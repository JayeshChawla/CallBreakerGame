//
//  GameScene.swift
//  Call_Breaker_Game
//
//  Created by MACPC on 19/04/24.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    let cardWidth = ScreenSize.width * 0.075
    let cardHeight = ScreenSize.height * 0.23
    let gapBetweenCard: CGFloat = 10
    
    var rightPlayerSelectedSuit: CardSuit? = nil // Tracking
    var cards: [SKSpriteNode] = []
    var cardInfoArray: [CardModel] = []
    var highestRank: CardRank? = nil
    
    var player1Hand: [SKSpriteNode] = []
    var player2Hand: [SKSpriteNode] = []
    var player3Hand: [SKSpriteNode] = []
    var player4Hand: [SKSpriteNode] = []
    var shuffledCards: [SKSpriteNode] = []
    var removecard : [SKSpriteNode] = []

    
    
    let cardBackTexture = SKTexture(imageNamed: "cards")
    let cardFrontTextures: [SKTexture] = {
          var textures = [SKTexture]()
          for suit in CardSuit.allValues {
              for rank in CardRank.allValue {
                  let texture = SKTexture(imageNamed: "\(suit.rawValue)\(rank.rawValue)")
                  textures.append(texture)
              }
          }
          return textures
      }()
    
    var background : SKSpriteNode = {
        var sprite = SKSpriteNode(imageNamed: "background")
        sprite.scaleTo(screenWidthPercentage: 1.0)
        sprite.zPosition = 1
        return sprite
    }()
    
    override func didMove(to view: SKView) {
        setupnode()
        addchildnode()
        setupTable()
        distributeCardsToPlayers(cards.shuffled())
        populateCardInfoArray()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        // Define touch regions for each player
        let leftPlayerRegion = CGRect(x: 0, y: 0, width: ScreenSize.width * 0.1, height: ScreenSize.height * 0.6)
        let rightPlayerRegion = CGRect(x: ScreenSize.width * 0.7, y: 0, width: ScreenSize.width * 0.3, height: ScreenSize.height)
        let topPlayerRegion = CGRect(x: ScreenSize.width * 0.3, y: ScreenSize.height * 0.6, width: ScreenSize.width * 0.4, height: ScreenSize.height * 0.4)
        let bottomPlayerRegion = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height * 0.2)
        
        var playerIndex = -1
        if leftPlayerRegion.contains(touchLocation) && !bottomPlayerRegion.contains(touchLocation) {
            playerIndex = 0 // Left player
        } else if rightPlayerRegion.contains(touchLocation) && !bottomPlayerRegion.contains(touchLocation) {
            playerIndex = 1 // Right player
        } else if topPlayerRegion.contains(touchLocation) {
            playerIndex = 2 // Top player
        } else if bottomPlayerRegion.contains(touchLocation)  {
            playerIndex = 3 // Bottom player
        }
        
        // If the touch is within any player's region, proceed
        if playerIndex != -1 {
            for (index, card) in cards.reversed().enumerated() {
                if card.contains(touchLocation) {
                    // Remove the card from the array
                    cards.remove(at: cards.count - 1 - index)
                    moveCardToMiddle(card, playerIndex: playerIndex)
                    
                    if let cardIndex = player4Hand.firstIndex(of: card) {
                        let removeCard = player4Hand.remove(at: cardIndex)
                        removecard.append(removeCard)
                    }else if let cardIndex = player3Hand.firstIndex(of: card){
                        let removeCard = player3Hand.remove(at: cardIndex)
                        removecard.append(removeCard)
                    }else if let cardIndex = player2Hand.firstIndex(of: card){
                        let removedCard = player2Hand.remove(at: cardIndex)
                        removecard.append(removedCard)
                    } else if let cardIndex = player1Hand.firstIndex(of: card){
                        let removedCard = player1Hand.remove(at: cardIndex)
                        removecard.append(removedCard)
                    }
                    let removedCardNames = removecard.compactMap{ $0.name }
                    let removedCardNamesString = removedCardNames.joined(separator: ",")
                    for removecard in removecard {
                        if let cardname = removecard.name{
                            print("Removed : \(cardname)")
                        }
                    }
                    print("Removed Cards: \(removedCardNamesString)")
                    
                    for card in removecard {
                        if let rank = extractRank(from: card) {
                            if highestRank == nil || rank.rawValue > highestRank!.rawValue {
                                highestRank = rank
                            }
                            if rank == .Ace {
                              highestRank = rank
                                break // No need to continue checking if Ace is found
                            }
                        }
                    }

                    // Print the highest-ranking card if found
                    if let highestRank = highestRank {
                        print("Highest Ranking card: \(highestRank.strValue())")
                    } else {
                        print("No cards found in removecard.")
                    }
                   identifyingWinningPlayer()
                    break
                   
                }
            }
        }
        
    }

    func identifyingWinningPlayer() {
        // Extract the ranks of cards in the removecard array
        let cardRanks = removecard.compactMap { extractRank(from: $0) }
        
        // Find the highest ranking card in the array
        if let highestRank = cardRanks.max() {
          print("Highest Ranking card: \(highestRank.strValue())")
            if highestRank == .Ace {
                       print("An Ace is the highest card.")
                       return
                   }
            // Determine which player has the highest-ranking card
            for (index, card) in removecard.enumerated() {
                if let rank = extractRank(from: card), rank == highestRank {
                    print("Player \(index + 1) wins with the highest card: \(highestRank.strValue())")
                    if removecard.count == 4 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.moveCardsAfterWin(playerIndex: index)
                        }
                    } else {
                        print("Waiting for all cards to be collected.")
                    }
                    return
                }
            }
            
            // If no player has the highest card, print no player wins
            print("No player wins.")
        } else {
            print("No cards found in removecard.")
        }
    }
    func moveCardsAfterWin(playerIndex: Int) {
        var moveDistanceY: CGFloat = 0
        var moveDistanceX : CGFloat = 0
        switch playerIndex {
           case 0: // Player 1 (left side)
               moveDistanceY = -400 // Move cards downwards
           case 1: // Player 2 (right side)
               moveDistanceX = 400 // Move cards to the right
           case 2: // Player 3 (top center)
               moveDistanceY = 400 // Move cards upwards
           case 3: // Player 4 (bottom center)
               moveDistanceX = -400 // Move cards to the left
           default:
               break
           }

        for (index, card) in removecard.enumerated() {
            let moveAction = SKAction.moveBy(x: moveDistanceX, y: moveDistanceY, duration: 0.5)
            card.run(moveAction) {
                card.removeFromParent()
                if index == self.removecard.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.removecard.removeAll()
                        // Additional actions after delay
                    }
                }
            }
        }
    }


    
    func extractRank(from card: SKSpriteNode) -> CardRank? {
        guard let cardName = card.name else { return nil }
        let components = cardName.components(separatedBy: " ")
        guard components.count >= 3 else { return nil }
        let rankString = components[0]
        
        switch rankString {
        case "Ace": return .Ace
        case "King": return .King
        case "Queen": return .Queen
        case "Jack": return .Jack
        case "Ten": return .Ten
        case "Nine": return .Nine
        case "Eight": return .Eight
        case "Seven": return .Seven
        case "Six": return .Six
        case "Five": return .Five
        case "Four": return .Four
        case "Three": return .Three
        case "Two": return .Two
        default: return nil
        }
    }



    func player4Handd(){
        print("Cards for player 1")
        for card in player4Hand {
            if let cardName = card.name {
                print(cardName)
            }
        }
    }
    
    func populateCardInfoArray() {
        for suit in CardSuit.allValues {
            for rank in CardRank.allValue {
                let card = CardModel(suit: suit, rank: rank)
                cardInfoArray.append(card)
            }
        }
    }


    
    func setupnode(){
        background.position = CGPoint(x: ScreenSize.maxLength * 0.5, y: ScreenSize.height * 0.5)
    }
    func addchildnode(){
        addChild(background)
    }
    
    func setupTable() {
        let totalCardWidth = CGFloat(CardSuit.allValues.count) * cardWidth + CGFloat(CardSuit.allValues.count - 1) * gapBetweenCard
        let startX = ScreenSize.width / 2
        let startY = ScreenSize.height / 2 - 250
        
        for suit in CardSuit.allValues {
            for rank in CardRank.allValue {
                let model = CardModel(suit: suit, rank: rank)
                var cardName: String
                switch rank {
                    case .Two: cardName = "Two"
                    case .Three: cardName = "Three"
                    case .Four: cardName = "Four"
                    case .Five: cardName = "Five"
                    case .Six: cardName = "Six"
                    case .Seven: cardName = "Seven"
                    case .Eight: cardName = "Eight"
                    case .Nine: cardName = "Nine"
                    case .Ten: cardName = "Ten"
                    case .Jack: cardName = "Jack"
                    case .Queen: cardName = "Queen"
                    case .King: cardName = "King"
                    case .Ace: cardName = "Ace"
                }
        
                let card = SKSpriteNode(imageNamed: "\(suit.rawValue)\(rank.rawValue)")
                card.name = "\(cardName) of \(suit.rawValue)"
                card.zPosition = 2
                card.size = CGSize(width: cardWidth, height: cardHeight)
                card.position = CGPoint(x: startX, y: startY)
                addChild(card)
                cards.append(card)
                print("Added card: \(card.name ?? "")")
            }
        }
    }


    func distributeCardsToPlayers(_ shuffledCards: [SKSpriteNode]) {
        let center = CGPoint(x: ScreenSize.width / 2, y: ScreenSize.height / 2)
        let leftCenter = CGPoint(x: ScreenSize.width * 0.03, y: center.y)
        let rightCenter = CGPoint(x: ScreenSize.width * 0.97, y: center.y)
        let topCenter = CGPoint(x: center.x, y: ScreenSize.height * 0.95)
        let bottomCenter = CGPoint(x: center.x, y: ScreenSize.height * 0.1)
        let card = shuffledCards

        let shuffledCards = cards
        let cardsPerPlayer = shuffledCards.count / 4

        // Define the spread (in degrees for better understanding)
        let maxRotationDegrees = 20.0
        let maxRotation = CGFloat(maxRotationDegrees * .pi / 180)
        


        for (index, card) in shuffledCards.enumerated() {
//            print("Index: \(index)")
            var destination: CGPoint
            var rotation: CGFloat = 0
            
            let playerIndex = index / cardsPerPlayer
            let cardIndex = CGFloat(index % cardsPerPlayer)
            let middleIndex = CGFloat(cardsPerPlayer - 1) / 2

            // Calculate rotation for each card based on its position in the hand
            rotation = -maxRotation * (cardIndex - middleIndex) / middleIndex

            // Calculate the horizontal and vertical offset based on player position
            let overlapFactor = cardWidth * 0.1  // Controls how much cards overlap
            let horizontalOffset = (cardIndex - middleIndex) * overlapFactor
            let verticalAdjustment = abs(horizontalOffset) * tan(abs(rotation))
            
            let totalCardWidth = CGFloat(cardsPerPlayer) * cardWidth
                let totalGapWidth = ScreenSize.width - totalCardWidth
                let gapBetweenCards = totalGapWidth / CGFloat(cardsPerPlayer - 1)
                
                let reducedCardWidth = min(cardWidth, (ScreenSize.width - gapBetweenCards * CGFloat(cardsPerPlayer - 1)) / CGFloat(cardsPerPlayer))
                let reducedCardHeight = cardHeight * (reducedCardWidth / cardWidth)

            switch playerIndex {
            case 0: // Player 1 (left side)
                rotation = -rotation
                destination = CGPoint(x: leftCenter.x + verticalAdjustment, y: leftCenter.y + horizontalOffset)
                rotation += .pi / 2  // Adjust based on rotation
                player1Hand.append(card)
            case 1: // Player 2 (right side)
                destination = CGPoint(x: rightCenter.x + verticalAdjustment, y: rightCenter.y + horizontalOffset)
                rotation += .pi / 2
                player2Hand.append(card)
            case 2: // Player 3 (top center)
                rotation = -rotation
                destination = CGPoint(x: topCenter.x + horizontalOffset, y: topCenter.y)
                destination.y += verticalAdjustment
                player3Hand.append(card)
            case 3: // Player 4 (bottom center)
                destination = bottomCenter
                player4Hand.append(card)
                
                
            default:
                destination = center
            }
//
            if playerIndex != 3 {
                let rotateAction = SKAction.rotate(toAngle: rotation, duration: 0)
                card.run(rotateAction)
            }
            if index / cardsPerPlayer == 3 {
                let bottomCards = shuffledCards.suffix(cardsPerPlayer)
                let startX = ScreenSize.width * 0.53 - totalCardWidth * 0.5
                        destination = CGPoint(x: startX + CGFloat(index % cardsPerPlayer) * (reducedCardWidth), y: bottomCenter.y)
                let delayAction = SKAction.wait(forDuration: 3.0)
                
                let flipAction = SKAction.run { [weak self] in
                    for card in bottomCards {
//                        self?.flipCard(card)
                    }
                    
                }
                self.run(SKAction.sequence([delayAction, flipAction]))
            }
            // Move card to the destination with some delay for animation effect
            let delay = TimeInterval(index % cardsPerPlayer) * 0.1
            let moveAction = SKAction.move(to: destination, duration: 0.5)
            card.run(SKAction.sequence([SKAction.wait(forDuration: delay), moveAction]))
            
            print("Index: \(index), Card: \(card.name ?? "Unknown")")
        }
    }

    func flipCard(_ card: SKSpriteNode) {
        let flipDuration: TimeInterval = 0.5
        let flipOutAction = SKAction.scaleX(to: 0.0, duration: flipDuration / 2)
        let changeTextureAction = SKAction.run {
            if card.texture == self.cardBackTexture {
                let newTexture = self.cardFrontTextures.randomElement() ?? self.cardBackTexture
                card.texture = newTexture
            }
        }
        let flipInAction = SKAction.scaleX(to: 1.0, duration: flipDuration / 2)
        let flipSequence = SKAction.sequence([flipOutAction, changeTextureAction, flipInAction])
        card.run(flipSequence)
    }


    func moveCardToMiddle(_ card: SKSpriteNode, playerIndex: Int) {
        var destination = CGPoint.zero
        var rotation : CGFloat = 0
        
        switch playerIndex {
        case 0: // Player 1 (left side)
            destination = CGPoint(x: ScreenSize.width * 0.45, y: ScreenSize.height * 0.5)
            rotation = .pi / 2
            flipCard(card)
        case 1: // Player 2 (right side)
            destination = CGPoint(x: ScreenSize.width * 0.55, y: ScreenSize.height * 0.5)
            rotation = .pi / 2
            flipCard(card)

        case 2: // Player 3 (top center)
            destination = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.55)
            flipCard(card)

        case 3: // Player 4 (bottom center)
            destination = CGPoint(x: ScreenSize.width * 0.5, y: ScreenSize.height * 0.45)
        default:
            break
        }
        // Move the card to the destination
        let moveAction = SKAction.move(to: destination, duration: 0.5)
        let rotateAction = SKAction.rotate(toAngle: rotation, duration: 0.5)
        card.zRotation = 0
        card.run(SKAction.group([moveAction , rotateAction]))
    }

}




    

