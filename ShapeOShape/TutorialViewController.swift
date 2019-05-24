//
//  TutorialViewController.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 24/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController {
    
    let colors = [
        "AppBlue",
        "AppGreen",
        "AppOrange",
        "AppPurple",
        "AppRed",
    ]
    
    let shapes = [
        "Rect",
        "Right Triangle",
        "Rounded rect",
        "Triangle",
        "Up arrow",
    ]
    
    // MARK:- Outlets
    @IBOutlet weak var shapeOne: UIImageView!
    @IBOutlet weak var shapeTwo: UIImageView!
    @IBOutlet weak var shapeThree: UIImageView!
    @IBOutlet weak var shapeFour: UIImageView!
    @IBOutlet weak var shapeFive: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var scoreLabelBackground: UIView!
    @IBOutlet weak var choiceOne: UIView!
    @IBOutlet weak var choiceTwo: UIView!
    @IBOutlet weak var choiceThree: UIView!
    @IBOutlet weak var choiceFour: UIView!
    @IBOutlet weak var choiceFive: UIView!
    @IBOutlet weak var countdownProgressView: UIProgressView! {
        didSet {
            countdownProgressView.transform = CGAffineTransform(scaleX: 1, y: 1.1)
            countdownProgressView.tintColor = UIColor(named: "AppYellow")
            countdownProgressView.layer.cornerRadius = 10
            countdownProgressView.clipsToBounds = true        }
    }
    
    var choiceOutletsArray: [UIView] {
        return [choiceOne, choiceTwo, choiceThree, choiceFour, choiceFive]
    }
    var shapesViewArray: [UIImageView] {
        return [shapeOne, shapeTwo, shapeThree, shapeFour, shapeFive]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let colorsReversed = Array(colors.reversed())
        for (index, shapeImageView) in shapesViewArray.enumerated() {
            shapeImageView.image = UIImage(named: shapes[index])
            shapeImageView.tintColor = UIColor(named: colors[index])
            choiceOutletsArray[index].backgroundColor = UIColor(named: colorsReversed[index])
        }
        
        let shapeToAnimate = shapesViewArray[0]
        let choiceViewToAnimate = choiceOutletsArray[4]
        
        animateTransformScaleUp(withView: shapeToAnimate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.animateTransformScaleDown(withView: choiceViewToAnimate)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            self.animateTransformScaleUp(withView: self.shapesViewArray[1])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
            self.animateTransformScaleDown(withView: self.choiceOutletsArray[3])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 19) {
            let alert = UIAlertController(title: "😎", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "👍🏼", style: .default, handler: { _ in
                self.performSegue(withIdentifier: "toFirstStageVC", sender: self)
            })
            let cancelAction = UIAlertAction(title: "🙅🏻‍♂️🙅🏻‍♀️", style: .destructive, handler: nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    func animateTransformScaleUp(withView: UIView) {
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                withView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                withView.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                withView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                withView.transform = .identity
            })
        }, completion: nil)
    }
    
    func animateTransformScaleDown(withView: UIView) {
        UIView.animateKeyframes(withDuration: 4, delay: 0, options: .calculationModeLinear, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                withView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                withView.transform = .identity
            })
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25, animations: {
                withView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                withView.transform = .identity
            })
        }, completion: nil)
    }
}
