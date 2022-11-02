//
//  TostMessageView.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/10/19.
//

import Foundation
import UIKit


extension UIView {
    func toastMessage(_ message: String) {
        let appearElement = Animation.appearElement
        let disappearElement = Animation.disappearElemet
        
        let messageView = ToastMessageView(positionWidth: 25,offset: 120,message)
        
        
        UIApplication.shared.keyWindow?.addSubview(messageView)
        
        UIView.animate(
             withDuration: appearElement.duration,
             delay: appearElement.delay,
             options: appearElement.options,
             animations: {
                 messageView.transform = appearElement.scale
                 messageView.alpha = appearElement.alpha
             }
             ,completion: {_ in
                 
                 UIView.animate(
                      withDuration: disappearElement.duration,
                      delay: disappearElement.delay,
                      options: disappearElement.options,
                      animations: {
                          messageView.transform = disappearElement.scale
                          messageView.alpha = disappearElement.alpha
                      }
                      ,completion: {_ in
                          messageView.removeFromSuperview()
                      })
             })
         }
    }


private enum Animation {
    typealias Element = (
        duration: TimeInterval,
        delay: TimeInterval,
        options: UIView.AnimationOptions,
        scale: CGAffineTransform,
        alpha: CGFloat
    )
    
   static var appearElement: Element {
        return Element(
            duration: 0.4,
            delay: 0,
            options: .curveLinear,
            scale: .init(scaleX: 1.0, y: 1.0),
            alpha: 1.0
        )
    }
    static var disappearElemet: Element {
         return Element(
            duration: 0.4,
            delay: 0.5,
             options: .curveLinear,
             scale: .init(scaleX: 1.0, y: 1.0),
             alpha: 0
         )
     }
    
}

struct Position {
    
    static let screenWidth = UIApplication.shared.keyWindow?.frame.width ?? 0
    static let screenHeihgt = UIApplication.shared.keyWindow?.frame.height ?? 0
    
    static func getPosition(_ xPosition: CGFloat,
                                  _ yOffset: CGFloat,
                                  _ yPosition: CGFloat = screenHeihgt,
                                  _ defaultHeight: CGFloat = 30)  -> CGRect {
       
        return CGRect(x: xPosition,
                      y: yPosition - yOffset ,
                      width: Position.screenWidth - (xPosition * 2),
                      height: defaultHeight)
       }
    
}

class ToastMessageView: UIView {
    
    var message: String?
    
    private lazy var toastContainer: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private lazy var toastLabel: UILabel = {
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.alpha = 0
        self.backgroundColor = .black
        self.layer.cornerRadius = 8
        
        self.addSubview(toastLabel)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        toastLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    convenience init(positionWidth: CGFloat, offset: CGFloat = 0, _ messgae: String) {
        self.init(frame: Position.getPosition(positionWidth, offset))
        self.toastLabel.text = messgae
    }
    
    required init?(coder: NSCoder) {
        fatalError("required init fatalError")
        
    }
    
}

