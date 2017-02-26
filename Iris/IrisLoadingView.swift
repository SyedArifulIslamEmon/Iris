//
//  IrisLoadingView.swift
//  Iris
//
//  Created by Eric Wang on 2/26/17.
//  Copyright © 2017 EricWang. All rights reserved.
//

import UIKit

class IrisLoadingView: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        loadingIndicator.startAnimating()
    }
    
    func dismissLoadingScreen(completion: (() -> Void)? = nil) {
        loadingIndicator.stopAnimating()
        self.dismiss(animated: true) { 
            completion?()
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
