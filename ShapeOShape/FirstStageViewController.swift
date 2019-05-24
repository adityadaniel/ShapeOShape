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
    let colors = [
        "AppBlue",
        "AppGreen",
        "AppOrange",
        "AppPurple",
        "AppRed",
        "AppYellow"
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
        "Rect w hole",
        "Rect",
        "Right Triangle",
        "Rounded rect",
        "Triangle",
        "Up arrow",
    ]
    
    var correctColorSequences: [UIColor] = []
    var colorTapped: [UIColor] = []
    var correctAnswer: [Bool] = []
    var outletsArray: [UIView] {
        return [choiceOne, choiceTwo, choiceThree, choiceFour, choiceFive]
    }
    var shapesViewArray: [UIImageView] {
        return [shapeOne, shapeTwo, shapeThree, shapeFour, shapeFive]
    }
    
    var timer: Timer?
    var gameTime = 7
    var timerIsRunning = false
    var score = 0
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countdownProgressView.progress = 1
        scoreLabel.text = "\(score)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
        
        outletsArray.forEach { (choiceOutlet) in
            let gesture = UITapGestureRecognizer(target: self, action: #selector(handleChoiceTap(sender:)))
            gesture.numberOfTapsRequired = 1
            
            choiceOutlet.isUserInteractionEnabled = true
            choiceOutlet.addGestureRecognizer(gesture)
        }
    }
    
    @objc func updateProgressBar() {
        gameTime -= 1
        if gameTime == 0 {
            timer?.invalidate()
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
            randomColorsArray.insert(UIColor(named: colors[colorIndex]) ?? .blue)
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
        
        UIView.animate(withDuration: 0.3) {
            choiceView.transform = CGAffineTransform(scaleX: 0.9, y: 0.95)
        }
        
        guard let choiceViewBackgroundColor = choiceView.backgroundColor else { return }
        colorTapped.append(choiceViewBackgroundColor)
        if colorTapped.count == 5 {
            evaluate()
        }
        
        
    }
    
    func resetScreen() {
        let colorArray = generateRandomColors()
        let shapeArray = generateShapes()
        let colorArrayShuffled = colorArray.shuffled()
        
        for (index, outletView) in outletsArray.enumerated() {
            outletView.backgroundColor = colorArray[index]
        }
        
        for (index, shapeImageView) in shapesViewArray.enumerated() {
            shapeImageView.image = UIImage(named: shapeArray[index])
            shapeImageView.tintColor = colorArrayShuffled[index]
            correctColorSequences.append(colorArrayShuffled[index])
        }
        
        gameTime += 5
        updateProgressBar()
    }
    
    func evaluate() {
        for (index, _) in colorTapped.enumerated() {
            if colorTapped[index] == correctColorSequences[index] {
                correctAnswer.append(true)
            } else {
                correctAnswer.append(false)
            }
        }
        
        let correctAnswerCount = correctAnswer.filter{ $0 == true}.count
        if correctAnswerCount == 5 {
            correctAnswer = []
            colorTapped = []
            score += 5
            print("Success")
            resetScreen()
        } else {
            correctAnswer = []
            colorTapped = []
            let alert = UIAlertController(title: "😎", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "👍🏼", style: .default) { _ in
                self.resetScreen()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    
        outletsArray.forEach { outletView in
            UIView.animate(withDuration: 0.3, animations: {
                outletView.transform = .identity
            })
        }
        
    }
}
