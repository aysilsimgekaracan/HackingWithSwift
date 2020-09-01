//
//  ViewController.swift
//  Project8
//
//  Created by Ayşıl Simge Karacan on 8.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    // We want to add a property observer to our score property so that we update the score label whenever the score value was changed
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var level = 1
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        // A Boolean value that determines whether the view’s autoresizing mask is translated into Auto Layout constraints.
        //If you want to use Auto Layout to dynamically calculate the size and position of your view, you must set this property to false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        
        //The default value for this property is 1. To remove any maximum limit, and use as many lines as needed, set the value of this property to 0.
        cluesLabel.numberOfLines = 0
        
        //Content hugging priority determines how likely this view is to be made larger than its intrinsic content size. If this priority is high it means Auto Layout prefers not to stretch it; if it’s low, it will be more likely to be stretched.
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        
        // addTarget -> Associates a target object and action method with the control.
        // touchUpInside -> A touch-up event in the control where the finger is inside the bounds of the control.
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
        ])
        
        let width = 150
        let height = 80
        
        for row in 0..<4 {
            for column in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        // It adds a safety check to read the title from the tapped button, or exit if it didn’t have one for some reason.
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        // Appends that button title to the player’s current answer.
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        
        // Appends the button to the activatedButtons array
        activatedButtons.append(sender)
        
        // Hides the button that was tapped.
//        sender.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            sender.alpha = 0
        }) { finished in
            sender.isHidden = true
        }
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        // firstIndex -> Returns the first index where the specified value appears in the collection.
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            // Reaching answers Label and creating an arr
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            
            splitAnswers?[solutionPosition] = answerText
            // Change answer label to the answer text
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            //scoreLabel.text = "Score: \(score)"
            
            //score % 7 == 0
            
            if letterButtons.allSatisfy({$0.isHidden}) {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        } else {
            let ac = UIAlertController(title: "Incorrect guess", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { [self] _ in
                self.currentAnswer.text = ""
                
                for button in self.activatedButtons {
                    //button.isHidden = false
                    UIView.animate(withDuration: 0.3, animations: {
                        button.alpha = 1
                    }) { finished in
                        button.isHidden = false
                    }
                }
                
                self.activatedButtons.removeAll()
            }))
            
            present(ac, animated: true)
            
            if score != 0 {
                score -= 1
            }
        }
    }
    
    
    func levelUp(action: UIAlertAction) {
        // Add 1 to level.
        level += 1
        
        // Remove all items from the solutions array.
        solutions.removeAll(keepingCapacity: true)
        
        // Call loadLevel() so that a new level file is loaded and shown.
        loadLevel()
        
        // Make sure all our letter buttons are visible.
        for button in letterButtons {
            //button.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                button.alpha = 1
            }) { finished in
                button.isHidden = false
            }
        }
    }

    // This method removes the text from the current answer text field, unhides all the activated buttons, then removes all the items from the activatedButtons array.
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
           // button.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                button.alpha = 1
            }) { finished in
                button.isHidden = false
            }
        }
        
        activatedButtons.removeAll()
    }
    
    // Load and parse our level text file in the format
    // Randomly assign letter groups to buttons.
    func loadLevel() {
        var clueString = ""
        var solutionsString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                // enumerated -> it passes you each object from an array as part of your loop, as well as that object's position in the array
                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionsString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        
        // trimmingCharacters(in:) removes any letters you specify from the start and end of a string. It's most frequently used with the parameter .whitespacesAndNewlines, which trims spaces, tabs and line breaks, and we need exactly that here because our clue string and solutions string will both end up with an extra line break.

        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterButtons.shuffle()
        
        if letterButtons.count == letterBits.count {
            for i in 0..<letterButtons.count {
                // setTitle -> Sets the title to use for the specified state.
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
        
    }


}

