//
//  ScoreViewController.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 25/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import UIKit
import AudioToolbox


class ScoreViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(restartGame))
            gesture.numberOfTapsRequired = 1
            
            scoreLabel.isUserInteractionEnabled = true
            scoreLabel.addGestureRecognizer(gesture)
            
        }
    }
    
    var score: Int = 0
    
    @objc func restartGame() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "FirstStageViewController") as! FirstStageViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(score)"
        
        AudioServicesPlayAlertSound(1304)
    }


}
