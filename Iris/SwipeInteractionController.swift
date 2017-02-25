//
//  SwipeInteractionController.swift
//  Iris
//
//  Created by Eric Wang on 2/25/17.
//  Copyright © 2017 EricWang. All rights reserved.
//

import UIKit

class SwipeInteractionController: UIPercentDrivenInteractiveTransition {
    
    var interactionInProgress = false
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    func wireToViewController(viewController: UIViewController!, swipeDirectionLeft: Bool) {
        self.viewController = viewController
        prepareGestureRecognizerInView(view: viewController.view, swipeDirectionLeft: swipeDirectionLeft)
    }
    
    private func prepareGestureRecognizerInView(view: UIView, swipeDirectionLeft: Bool) {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:)))
        
        // gesture.edges = swipeDirectionLeft ? UIRectEdge.left : UIRectEdge.right
        
        view.addGestureRecognizer(gesture)
    }
    
    func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        var progress = (translation.x / 200)
        progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
        
        print(translation.x)
        print(progress)
        
        switch gestureRecognizer.state {
        case .began:
            interactionInProgress = true
            viewController.dismiss(animated: true, completion: nil)
            break
        case .changed:
            interactionInProgress = false
            update(progress)
            break
        case .ended, .cancelled:
            interactionInProgress = false
            
            if !shouldCompleteTransition {
                cancel()
            } else {
                finish()
            }
            break
        default:
            print("unsupported")
            break
        }
    }
}
