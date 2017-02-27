//
//  TransitionManager.swift
//  Iris
//
//  Created by Eric Wang on 2/25/17.
//  Copyright © 2017 EricWang. All rights reserved.
//

import UIKit

class TransitionManager : UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var interactive = false
    private var isPresenting = false
    var isCamera = false
    
    private var panGesture: UIPanGestureRecognizer!
    
    var viewController: UIViewController! {
        didSet {
            self.panGesture = UIPanGestureRecognizer()
            self.panGesture?.addTarget(self, action: #selector(handlePanGesture(gestureRecognizer:)))
            self.viewController.view.addGestureRecognizer(panGesture!)
        }
    }
    
    func handlePanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let distance = translation.x / gestureRecognizer.view!.bounds.width
        
        var d: CGFloat?
        d = isCamera ? distance : -distance
        
        switch gestureRecognizer.state {
        case .began:
            self.interactive = true
            
            if isCamera {
                self.viewController.performSegue(withIdentifier: "pushToCloset", sender: self)
            } else {
                self.viewController.performSegue(withIdentifier: "unwindToCamera", sender: self)
            }
            break
        case .changed:
            self.update(d!)
            break
        default:
            self.interactive = false
            self.finish()
        }
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        let offScreenRight = CGAffineTransform(translationX: container.frame.width, y: 0)
        let offScreenLeft = CGAffineTransform(translationX: -container.frame.width, y: 0)
        
        toView.transform = isPresenting ? offScreenLeft : offScreenRight
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [], animations: {
            fromView.transform = self.isPresenting ? offScreenRight : offScreenLeft
            toView.transform = CGAffineTransform.identity
        }) { ( finished ) in
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.15
    }
    
    // MARK: UIViewController Transitioning Delegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    // MARK: Interactive Delegate
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
}
