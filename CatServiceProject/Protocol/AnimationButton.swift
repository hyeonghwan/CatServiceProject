//
//  AnimationButton.swift
//  CatServiceProject
//
//  Created by 박형환 on 2022/09/13.
//

import Foundation
import UIKit

class AnimationButton: UIButton {
    
  private enum Animation {
    typealias Element = (
      duration: TimeInterval,
      delay: TimeInterval,
      options: UIView.AnimationOptions,
      scale: CGAffineTransform,
      alpha: CGFloat
    )
    
    case touchDown
    case touchUp
    
    var element: Element {
      switch self {
      case .touchDown:
        return Element(
            duration: 0,
          delay: 0,
          options: .curveLinear,
          scale: .init(scaleX: 1.3, y: 1.3),
          alpha: 0.8
        )
      case .touchUp:
        return Element(
            duration: 0,
          delay: 0,
          options: .curveLinear,
          scale: .identity,
          alpha: 1
        )
      }
    }
  }
    var onCompleted: ((Bool) -> Void)?
  
  override var isHighlighted: Bool {
    didSet {
        
            self.animateWhenHighlighted()
       }
  }

    
   private func animateWhenHighlighted2() {
      let animationElement = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
      
      UIView.animate(
        withDuration: animationElement.duration,
        delay: animationElement.delay,
        options: animationElement.options,
        animations: {
          self.transform = animationElement.scale
          self.alpha = animationElement.alpha
        }
        ,completion: { [weak self] flag in
            
            guard let self = self else {print("self animation failed"); return}
            if self.isHighlighted == false {
                self.onCompleted?(self.isHighlighted)
            }
        })
    }
    

  private func animateWhenHighlighted() {
    let animationElement = self.isHighlighted ? Animation.touchDown.element : Animation.touchUp.element
    
    UIView.animate(
      withDuration: animationElement.duration,
      delay: animationElement.delay,
      options: animationElement.options,
      animations: {
        self.transform = animationElement.scale
        self.alpha = animationElement.alpha
      }
      ,completion: { [weak self] flag in
          guard let self = self else {print("self animation failed"); return}
          if self.isHighlighted == false {
              self.onCompleted?(self.isHighlighted)
          }
      })
  }
}
