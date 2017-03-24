//
//  MyAnimation.swift
//  DSAlert-Swift
//
//  Created by zeroLu on 16/9/1.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

import Foundation
import UIKit

extension CALayer {
    /*!
     *  晃动动画
     *
     *  @param duration 一次动画用时
     *  @param radius   晃动角度0-180
     *  @param repeatCount   重复次数
     *  @param finish   动画完成
     */
    func shakeAnimationWithDuration(duration:TimeInterval, radius : Double, repeatCount : Float, finish : ((Void) -> Void)?) {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.duration = duration
        keyAnimation.keyPath = "transform.rotation.z"
        keyAnimation.values = [NSNumber.init(value: (0) / 180.0 * M_PI as Double),
                               NSNumber.init(value: (-radius) / 180.0 * M_PI as Double),
                               NSNumber.init(value: (radius) / 180.0 * M_PI as Double),
                               NSNumber.init(value: (-radius) / 180.0 * M_PI as Double),
                               NSNumber.init(value: (0) / 180.0 * M_PI as Double)]
        keyAnimation.repeatCount = repeatCount
        self .add(keyAnimation, forKey: nil)
        
        if (finish != nil) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * Double(repeatCount) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                finish!()
            })
        }
    }
    
    /*!
     *  根据路径执行动画
     *
     *  @param duration 一次动画用时
     *  @param path     路径CGPathRef
     *  @param repeat   重复次数
     *  @param finish   动画完成
     */
    func pathAnimationWithDuration(duration:TimeInterval, path : CGPath, repeatCount : Float, finish : ((Void) -> Void)?) {
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.duration = duration
        keyAnimation.keyPath = "position"
        keyAnimation.repeatCount = repeatCount
        keyAnimation.fillMode = kCAFillModeForwards
        self .add(keyAnimation, forKey: nil)
        
        if (finish != nil) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(duration * (Double(repeatCount) - 0.1) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                finish!()
            })
        }
    }
    
    /*! 这两个动画只适合本项目 */
    /*! 天上掉下 */
    func fallAnimationWithDuration(duration:TimeInterval, finish : ((Void) -> Void)?) {
        let frame = UIScreen.main.bounds
        
        let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        
        let point = CGPoint(x: frame.width*0.5, y: -(self.frame.height))
        
        let path = UIBezierPath()
        
        path .move(to: point)
        
        path.addLine(to: center)
        
        self.pathAnimationWithDuration(duration: duration, path: path.cgPath, repeatCount: 1.0) { () in
            if (finish != nil)
            {
                finish!()
            }
        }
    }
    
    /*! 上升 */
    func floatAnimationWithDuration(duration:TimeInterval, finish : ((Void) -> Void)?) {
        let frame = UIScreen.main.bounds
        
        let center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        
        let point = CGPoint(x: frame.width*0.5, y: -(self.frame.height))
        
        let path = UIBezierPath()
        
        path .move(to: center)
        
        path.addLine(to: point)
        
        self.pathAnimationWithDuration(duration: duration, path: path.cgPath, repeatCount: 1.0) { () in
            if (finish != nil)
            {
                finish!()
            }
        }
    }
    
}

extension UIView {
    /**
     缩放显示动画
     
     - parameter finish: 动画完成
     */
    func scaleAnimationShowFinishAnimation(_ finish : ((Void) -> Void)?) {
        transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.35, animations: { 
            self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.25, animations: { 
                    self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }, completion: { (finifhed) in
                        if finished {
                            finish!()
                        }
                })
        }) 
    }
    /**
     缩放隐藏动画
     
     - parameter finish:   动画完成
     */
    func scaleAnimationDismissFinishAnimation(_ finish : ((Void) -> Void)?) {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 1.18, y: 1.18)
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.25, animations: {
                self.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }, completion: { (finifhed) in
                    if finished {
                        finish!()
                    }
            })
        }) 
    }
}
