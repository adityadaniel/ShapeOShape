//
//  ScoreViewController.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 25/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(restartGame))
            scoreLabel.addGestureRecognizer(gesture)
            
        }
    }
    
    var score: Int = 0
    
    @objc func restartGame() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        storyboard.instantiateViewController(withIdentifier: "<#T##String#>")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(score)"
    }


}
