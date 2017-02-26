//
//  ClosetViewController.swift
//  Iris
//
//  Created by Eric Wang on 2/10/17.
//  Copyright © 2017 EricWang. All rights reserved.
//

import UIKit

class ClosetViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var closetNavigationBar: UINavigationBar!
    @IBOutlet weak var closetCollectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        closetCollectionView.delegate = self
        closetCollectionView.dataSource = self
        closetCollectionView.showsVerticalScrollIndicator = false
        closetCollectionView.isUserInteractionEnabled = false 
    }
    
    // MARK: - UICollectionView Methods 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "closetCollectionCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ClosetCollectionViewCell
        
        cell.layer.cornerRadius = 4.0
        cell.clipsToBounds = true 
        
        cell.itemLabel.text = "The Rail Chelsea Boot"
        cell.itemImageView.image = UIImage(named: "ChelseaShoe")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let side = (closetCollectionView.frame.size.width - CGFloat(10)) / CGFloat(2)
        return CGSize(width: side, height: side)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // MARK: - IBAction
    @IBAction func returnToCamera(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "unwindToCamera", sender: self)
    }
}
