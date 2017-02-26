//
//  ResultsViewController.swift
//  Iris
//
//  Created by Eric Wang on 2/10/17.
//  Copyright © 2017 EricWang. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override func viewDidLoad() {
        resultsCollectionView.delegate = self
        resultsCollectionView.dataSource = self
        resultsCollectionView.showsHorizontalScrollIndicator = false
    }
    

    
    // MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = "resultsCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultsCollectionViewCell
        
        cell.layer.cornerRadius = 4.0
        cell.clipsToBounds = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = (resultsCollectionView.frame.size.width - CGFloat(10))
        let height = (resultsCollectionView.frame.size.height - CGFloat(20))
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func returnToCamera(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
