//
//  ViewController.swift
//  HybridAlgorithm
//
//  Created by zdaecqze zdaecq on 21.05.16.
//  Copyright © 2016 zdaecqze zdaecq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    var hybridAlgorithm = HybridAlgorithm()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hybridAlgorithm.controller = self
    }
    
    
    // MARK: - Actions
    @IBAction func actionStartAlgorithm(sender: AnyObject) {
        hybridAlgorithm.start()
    }
    
    @IBAction func actionClearCities(sender: AnyObject) {
        navigationItem.title = "Hybrid"
        hybridAlgorithm.clearResult()
    }
    
    
    // MARK: - Touch method
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        let touch = touches.first
        
        if let touchPoint = touch?.locationInView(self.view) {
            hybridAlgorithm.citiesArray.append(touchPoint)
            view.drawPoint(touchPoint, withRadius: 5)
        }
        
        navigationItem.title = "Cities count: \(hybridAlgorithm.citiesArray.count)"
    }
}

