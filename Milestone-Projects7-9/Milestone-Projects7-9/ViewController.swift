//
//  ViewController.swift
//  Milestone-Projects7-9
//
//  Created by Ayşıl Simge Karacan on 11.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var wordLabel: UILabel!
    var wordCountLabel: UILabel!
    
    var words = [String]()
    var usedWords = [String]()
    var lettersUsed = [String]()
    var letterButtons = [UIButton]()
    var currentWord = ""
    var wordCount = 0
    let letters = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
    
    var labelStr = "" {
        didSet {
            wordLabel.text = "\(labelStr)"
        }
    }
    
    var score = 0 {
        didSet {
            title = "Score: \(score)"
        }
    }
    
    override func loadView() {
        
        
        view = UIView()
        view.backgroundColor = .white
        
        title = "Score: \(score)"

        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 44)
        wordLabel.text = "WORD"
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(wordLabel)
        
        
        wordCountLabel = UILabel()
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountLabel.textAlignment = .right
        wordCountLabel.font = UIFont.systemFont(ofSize: 12)
        wordCountLabel.text = "\(wordCount) letters"
        view.addSubview(wordCountLabel)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        
        // MARK: CONSTRAINTS
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wordCountLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor),
            wordCountLabel.widthAnchor.constraint(equalTo: wordLabel.widthAnchor, constant: -50),

            buttonsView.widthAnchor.constraint(equalToConstant: 720),
            buttonsView.heightAnchor.constraint(equalToConstant: 530),
            buttonsView.topAnchor.constraint(equalTo: wordCountLabel.bottomAnchor, constant: 100),
            //buttonsView.centerXAnchor.constraint(equalTo: buttonsView.centerXAnchor),
            //buttonsView.centerYAnchor.constraint(equalTo: buttonsView.centerYAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 30),
            
        ])
        
        let width = 60
        let height = 40
        
        var column = 0
        var row = 0
        
        for idx in 0..<letters.count - 1 {
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            letterButton.setTitle("\(letters[idx].uppercased())", for: .normal)
            letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
            
            if idx % 7 == 0 {
                column = 0
                row += 1
            }
            
            let frame = CGRect(x: column * height, y: row * height, width: width, height: height)
            letterButton.frame = frame
            
            buttonsView.addSubview(letterButton)
            letterButtons.append(letterButton)
            
            column += 1
            
        }
        

      // END OF LOAD_VIEW
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let allWords = try? String(contentsOf: wordsURL) {
                words = allWords.components(separatedBy: "\n")
            }
        }
        
        
        loadWord()
        
        // END OF VIEW_DID_LOAD
    }
    
    func loadWord() {
        let unusedWords = words.filter { !usedWords.contains($0) }
        currentWord = unusedWords.randomElement()!.uppercased()
        
        labelStr = String(repeating: "?", count: currentWord.count)
        wordCountLabel.text = "\(currentWord.count) letters"
        
        for button in letterButtons {
            button.isHidden = false
        }
        
        lettersUsed.removeAll()
        
        print(currentWord)
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        lettersUsed.append(buttonTitle)
        
        // Hide the button
        sender.isHidden = true
        
        var tempStr = ""
        
        for letter in currentWord {
            if  lettersUsed.contains(String(letter)){
                tempStr += String(letter)
            } else {
                tempStr += "?"
            }
        }
        
        if tempStr == labelStr {
            errorMessage(title: "", message: "The letter you pressed is not in the word")
            score -= score != 0 ? 10 : 0
        } else {
            labelStr = tempStr
            score += 10
        }

        //Next Level
        if labelStr.contains("?") != true {
            errorMessage(title: "Congrats!", message: "Next Level!")
            loadWord()
        }
        
        
    }
    
    func errorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(ac, animated: true, completion: nil)

        // Dismiss the alert for 1 second
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          ac.dismiss(animated: true, completion: nil)
        }
    }


}

