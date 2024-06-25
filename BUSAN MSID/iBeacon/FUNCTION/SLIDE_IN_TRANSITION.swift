//
//  SLIDE_IN_TRANSITION.swift
//  iBeacon
//
//  Created by i-Mac on 2020/09/15.
//  Copyright © 2020 장제현. All rights reserved.
//

import UIKit

class SLIDE_IN_TRANSITION: NSObject, UIViewControllerAnimatedTransitioning {
    
    var IS_PRESENTING = false
    var TRANSFORM = false
    var ALPHA = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let TO_VC = transitionContext.viewController(forKey: .to),
            let FROM_VC = transitionContext.viewController(forKey: .from) else { return }
        
        let CONTAINER_VIEW = transitionContext.containerView
        
        let FINAL_WIDTH = TO_VC.view.bounds.width
        let FINAL_HEIGHT = TO_VC.view.bounds.height
        
        if IS_PRESENTING {
            
            CONTAINER_VIEW.addSubview(TO_VC.view)
            if TRANSFORM == true && ALPHA == false {
                TO_VC.view.frame = CGRect(x: FINAL_WIDTH, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT)
            } else if TRANSFORM == false && ALPHA == true {
                TO_VC.view.frame = CGRect(x: 0.0, y: 0.0, width: FINAL_WIDTH, height: FINAL_HEIGHT)
            }
        }
        
        let DURATION = transitionDuration(using: transitionContext)
        let IS_CANCELLED = transitionContext.transitionWasCancelled
        
        UIView.animate(withDuration: DURATION, animations: {
            if self.TRANSFORM == true && self.ALPHA == false {
                
                let TRANSFORM = { TO_VC.view.transform = CGAffineTransform(translationX: -FINAL_WIDTH, y: 0.0) }
                let IDENTITY = { FROM_VC.view.transform = .identity }
                
                self.IS_PRESENTING ? TRANSFORM() : IDENTITY()
            } else {
                
                let TRANSFORM = { TO_VC.view.alpha = 1.0 }
                let IDENTITY = { FROM_VC.view.alpha = 0.0 }
                
                self.IS_PRESENTING ? TRANSFORM() : IDENTITY()
            }
        }) { (_) in
            transitionContext.completeTransition(!IS_CANCELLED)
        }
    }
}

extension LOADING: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.TRANSFORM = true
        TRANSITION.ALPHA = false
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.TRANSFORM = true
        TRANSITION.ALPHA = false
        return TRANSITION
    }
}

extension SIGN_UP: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.TRANSFORM = false
        TRANSITION.ALPHA = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.TRANSFORM = false
        TRANSITION.ALPHA = true
        return TRANSITION
    }
}

extension HOME: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = true
        TRANSITION.TRANSFORM = false
        TRANSITION.ALPHA = true
        return TRANSITION
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        TRANSITION.IS_PRESENTING = false
        TRANSITION.TRANSFORM = false
        TRANSITION.ALPHA = true
        return TRANSITION
    }
}
