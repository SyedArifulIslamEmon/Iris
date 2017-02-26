//
//  ResultsCollectionViewCell.swift
//  Iris
//
//  Created by Eric Wang on 2/26/17.
//  Copyright © 2017 EricWang. All rights reserved.
//

import UIKit

class ResultsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var resultsImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productColorLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var otherOptionsButton: UIButton!
    
    @IBAction func purchaseItem(_ sender: UIButton) {
    }
    
    @IBAction func viewOtherPurchaseOptions(_ sender: UIButton) {
    }
}
