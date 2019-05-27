//
//  ViewController.swift
//  ShapeOShape
//
//  Created by Daniel Aditya Istyana on 21/05/19.
//  Copyright © 2019 Daniel Aditya Istyana. All rights reserved.
//

import UIKit

class FirstStageViewController: UIViewController {
    
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
    var gameTime = 15
    var cumulativeScore: Int = 0
    var timerIsRunning = false
    var firstStageGamePlayed = 0
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
            countdownProgressView.tintColor = Colors.appYellow
            countdownProgressView.layer.cornerRadius = 5
            countdownProgressView.clipsToBounds = true
        }
    }
    @IBOutlet weak var choiceStackView: UIStackView!
    
    // MARK:- Status bar style
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
    
    // MARK:- Prepare for segue to second view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSecondViewController" {
            if let destinationVC = segue.destination as? SecondViewController {
                destinationVC.cumulativeScore = cumulativeScore
            }
        } else if segue.identifier == "showScore" {
            if let destinationVC = segue.destination as? ScoreViewController {
                destinationVC.score = cumulativeScore
            }
        }
    }
    
    
    // MARK:- Update Progress bar
    @objc func updateProgressBar() {
        gameTime -= 1
        if gameTime == 0 {
            timer?.invalidate()
            self.performSegue(withIdentifier: "showScore", sender: nil)
        }
        
        let gameTimeConversion: Float = Float(gameTime) / 10
        if gameTimeConversion < 0.5 {
            countdownProgressView.tintColor = Colors.appYellow
        } else if gameTimeConversion < 0.3 {
            countdownProgressView.tintColor = Colors.appRed
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
        
        if choiceTagArray.count == 5 && choiceTagArray.difference(from: [1,2,3,4,5]) == []  {
            print("all choice is tapped")
            evaluate()
        }
    }
    
    // MARK:- evaluate games after all choice is selected
    func evaluate() {
        for (index, color) in colorTappedArray.enumerated() {
            if color == correctColorSequences[index] {
                answerArray.append(true)
            } else {
                answerArray.append(false)
            }
        }
        
        let colorMismatchCount = answerArray.filter{ $0 == false }.count
        
        print(colorMismatchCount)
        print("Color missed:", colorMismatchCount)
        
        // reset all array
        (colorTappedArray, correctColorSequences, choiceTagArray, answerArray) = ([], [], [], [])
        
        // updateScore
        if colorMismatchCount == 0 {
            cumulativeScore += 5
            firstStageGamePlayed += 1
            if firstStageGamePlayed == 4 {
                performSegue(withIdentifier: "showSecondViewController", sender: nil)
            }
        } else {
            cumulativeScore += colorMismatchCount
            performSegue(withIdentifier: "showScore", sender: nil)
        }
        
        // update scorelabel
        scoreLabel.text = "\(cumulativeScore)"
        
        gameTime += gameTime - firstStageGamePlayed
        
        resetScreen()
        
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
