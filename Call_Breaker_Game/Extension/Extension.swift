//
//  Extension.swift
//  Call_Breaker_Game
//
//  Created by MACPC on 19/04/24.
//

import UIKit
import SpriteKit

enum UIUserInterfaceIdiom : Int{
    case undefined
    case phone
    case pad
}
struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let maxLength = max(ScreenSize.width , ScreenSize.height)
    static let minLength = min(ScreenSize.width , ScreenSize.height)
}
struct DeviceType {
    static let isiPhone4OrLess = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength < 568.0
    static let isiPhone5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 568.0
    static let isiPhone6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 667.0
    static let isiPhone6plus = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 736.0
    static let isiPhoneX = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 812.0
    static let isiPad = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1024.0
    static let isiPadpro = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.maxLength == 1366.0
    static let isiPhone11 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 896.0
    static let isiPhone12 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 844.0
    static let isiPhone12Mini = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 780.0
    static let isiPhone12ProMax = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength == 926.0
    static let isiPhone13 = isiPhone12 // Since the dimensions are the same as iPhone 12
    static let isiPhone13Mini = isiPhone12Mini // Same dimensions as iPhone 12 Mini
    static let isiPhone13ProMax = isiPhone12ProMax // Same dimensions as iPhone 12 Pro Max
}

public extension CGFloat{
    public static func universalFont(size : CGFloat) -> CGFloat{
        if DeviceType.isiPhone4OrLess {
            return size * 0.06
        }
        if DeviceType.isiPhone5 {
            return size * 0.8
        }
        if DeviceType.isiPhone6 && DeviceType.isiPhone6plus && DeviceType.isiPhoneX && DeviceType.isiPhone11 && DeviceType.isiPhone12 && DeviceType.isiPhone12Mini && DeviceType.isiPhone13 && DeviceType.isiPhone13Mini && DeviceType.isiPhone13ProMax{
            return size * 1.0
        } else{
            return size * 1.0
        }
    }
    public static func random() -> CGFloat {
      return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(_ min: CGFloat, max: CGFloat) -> CGFloat {
      return CGFloat.random() * (max - min) + min
    }
    
}
extension SKSpriteNode {
  
  func scaleTo(screenWidthPercentage: CGFloat) {
    let aspectRatio = self.size.height / self.size.width
    self.size.width = ScreenSize.width * screenWidthPercentage
    self.size.height = self.size.width * aspectRatio
  }
  
  func scaleTo(screenHeightPercentage: CGFloat) {
    let aspectRatio = self.size.width / self.size.height
    self.size.height = ScreenSize.height * screenHeightPercentage
    self.size.width = self.size.height * aspectRatio
  }
}
