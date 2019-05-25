//
//  SecondViewController.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 24/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    // MARK:- Init Property
    let colors: [UIColor] = [
        Colors.appBlue,
        Colors.appGreen,
        Colors.appOrange,
        Colors.appPurple,
        Colors.appRed,
        Colors.appYellow,
    ]
    
    let shapes = [
        "Circle",
        "Down Arrow",
        "Down Triangle",
        "Heptagon",
        "Hexagon",
        "Left Triangle",
        "Moon",
        "Octagon",
        "Pentagon",
        "Rect",
        "Right Triangle",
        "Rounded rect",
        "Triangle",
        "Up arrow",
    ]
    
    var correctColorSequences: [UIColor] = []
    var colorTappedArray: [UIColor] = []
    var answerArray: [Bool] = []
    var outletsArray: [UIView] {
        return [choiceOne, choiceTwo, choiceThree, choiceFour, choiceFive]
    }
    var shapesViewArray: [UIImageView] {
        return [shapeOne, shapeTwo, shapeThree, shapeFour, shapeFive]
    }
    
    var timer: Timer?
    var gameTime = 10
    var cumulativeScore: Int = 0
    var timerIsRunning = false
    var secondStageGamePlayed = 0
    var maximumFirstStageGamePlayed = 3
    var choiceTagArray: [Int] = []
    
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let colorArray = generateRandomColors()
        let colorArrayShuffled = colorArray.shuffled()
        let shapeArray = generateShapes()
        
        for (index, outletView) in outletsArray.enumerated() {
            outletView.backgroundColor = colorArray[index]
        }
        
        for (index, shapeImageView) in shapesViewArray.enumerated() {
            shapeImageView.image = UIImage(named: shapeArray[index])
            shapeImageView.tintColor = colorArrayShuffled[index]
            correctColorSequences.append(colorArrayShuffled[index])
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                self.scoreLabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            }, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownProgressView.progress = 1
        scoreLabel.text = "\(cumulativeScore)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        
        outletsArray.forEach { (choiceOutlet) in
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleChoiceTap(sender:)))
            gesture.numberOfTapsRequired = 1
            
            choiceOutlet.isUserInteractionEnabled = true
            choiceOutlet.addGestureRecognizer(gesture)
        }
    }
    
    // MARK:- Prepare for segue to score
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showScore" {
            if let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.score = cumulativeScore
            }
        }
    }
    
    // MARK:- Update the progress bar
    @objc func updateProgressBar() {
        gameTime -= 1
        if gameTime == 0 {
            timer?.invalidate()
            self.performSegue(withIdentifier: "showScore", sender: nil)
        }
        
        let gameTimeConversion: Float = Float(gameTime) / 10
        if gameTimeConversion < 0.3 {
            countdownProgressView.tintColor = UIColor(named: "AppRed")
        }
        countdownProgressView.progress = Float(gameTimeConversion)
    }
    
    func generateRandomColors() -> Array<UIColor> {
        var randomColorsArray: Set<UIColor> = []
        while randomColorsArray.count < 5 {
            let colorIndex = Int.random(in: 0..<colors.count)
            randomColorsArray.insert(colors[colorIndex])
        }
        return Array(randomColorsArray)
    }
    
    func generateShapes() -> Array<String> {
        var randomShapesArray = Set<String>()
        while randomShapesArray.count < 5 {
            let randomShapeIndex = Int.random(in: 0..<shapes.count)
            randomShapesArray.insert(shapes[randomShapeIndex])
        }
        return Array(randomShapesArray)
    }
    
    @objc func handleChoiceTap(sender: UITapGestureRecognizer) {
        
        guard let choiceView = sender.view else { return }
        let viewTag = choiceView.tag
        
        
        // animate tapped
        UIView.animate(withDuration: 0.3) {
            choiceView.transform = CGAffineTransform(scaleX: 0.9, y: 0.95)
        }
        
        guard let choiceViewBackgroundColor = choiceView.backgroundColor else { return }
        
        colorTappedArray.append(choiceViewBackgroundColor)
        choiceTagArray.append(viewTag)
        
        if secondStageGamePlayed == 2 && choiceTagArray.count == 4 && choiceTagArray.difference(from: [1,2,4,5]) == [] {
            evaluate()
        } else {
            if choiceTagArray.count == 5 && choiceTagArray.difference(from: [1,2,3,4,5]) == []  {
                evaluate()
            }
        }
    }
    
    // MARK:- evaluate games after all choice is selected
    func evaluate() {
        let correctColorSequencesReversed = Array(correctColorSequences.reversed())
        
        for (index, color) in colorTappedArray.enumerated() {
            if color == correctColorSequencesReversed[index] {
                answerArray.append(true)
            } else {
                answerArray.append(false)
            }
        }
        
        let colorMismatchCount = answerArray.filter{ $0 == false }.count
        
        // reset all array
        (colorTappedArray, correctColorSequences, choiceTagArray, answerArray) = ([], [], [], [])
        
        // updateScore
        if colorMismatchCount == 0 {
            cumulativeScore += 5
            secondStageGamePlayed += 1
        } else {
            cumulativeScore += colorMismatchCount
            performSegue(withIdentifier: "showScore", sender: nil)
        }
        
        // update scorelabel
        scoreLabel.text = "\(cumulativeScore)"
        
        gameTime += gameTime - secondStageGamePlayed
        
        if secondStageGamePlayed == 2 {
            resetScreenToSpecialSurprise()
        } else {
            resetScreen()
        }
    }
    
    @objc func handleBackgroundScoreTap() {
        print("background color tapped")
        colorTappedArray.append(Colors.appLightGray)
    }
    
    func resetScreenToSpecialSurprise() {
        print("Special stage")
        let shapeColorArray = [Colors.appGreen, Colors.appRed, Colors.appLightGray, Colors.appPurple, Colors.appOrange]
        let colorArray = [Colors.appGreen, Colors.appRed, Colors.appYellow, Colors.appPurple, Colors.appOrange]
        let colorArrayReversed = Array(colorArray.reversed())
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundScoreTap))
        gesture.numberOfTapsRequired = 1
        
        self.scoreLabelBackground.isUserInteractionEnabled = true
        self.scoreLabelBackground.addGestureRecognizer(gesture)
        
        let shapeArray = generateShapes()
        
        for (index, shapeImageView) in shapesViewArray.enumerated() {
                shapeImageView.image = UIImage(named: shapeArray[index])
                shapeImageView.tintColor = shapeColorArray[index]
                correctColorSequences.append(shapeColorArray[index])
        }
        
        // set choiceOutletView background color
        for (index, outletView) in outletsArray.enumerated() {
            outletView.backgroundColor = colorArrayReversed[index]
            UIView.animate(withDuration: 0.5) {
                outletView.transform = .identity
            }
        }
        
    }
    
    // MARK:- Reset shape, color and timer
    func resetScreen() {
        let colorArray = generateRandomColors()
        let colorArrayShuffled = colorArray.shuffled()
        
        let shapeArray = generateShapes()
        
        for (index, shapeImageView) in shapesViewArray.enumerated() {
            shapeImageView.image = UIImage(named: shapeArray[index])
            shapeImageView.tintColor = colorArray[index]
            correctColorSequences.append(colorArray[index])
        }
        
        // set choiceOutletView background color
        for (index, outletView) in outletsArray.enumerated() {
            outletView.backgroundColor = colorArrayShuffled[index]
            UIView.animate(withDuration: 0.5) {
                outletView.transform = .identity
            }
        }
    }
}
