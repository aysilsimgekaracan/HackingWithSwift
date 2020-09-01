//
//  ViewController.swift
//  Project15
//
//  Created by Ayşıl Simge Karacan on 31.08.2020.
//  Copyright © 2020 Ayşıl Simge Karacan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imageView: UIImageView!
    var currentAnimation = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 512, y: 384)
        view.addSubview(imageView)
    }

    @IBAction func tapped(_ sender: UIButton) {
        sender.isHidden = true
        
//      UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
                
                // CGAffineTransform -> An affine transformation matrix is used to rotate, scale, translate, or skew the objects you draw in a graphics context. The CGAffineTransform type provides functions for creating, concatenating, and applying affine transformations.
                
            case 0:
                // Returns an affine transformation matrix constructed from scaling values you provide.
                self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                break
            case 1, 3, 5:
                // This effectively clears our view of any pre-defined transform, resetting any changes that have been applied by modifying its transform property.
                self.imageView.transform = .identity
            case 2:
                // This function creates a CGAffineTransform structure. which you can use (and reuse, if you want) to move a coordinate system.
                self.imageView.transform = CGAffineTransform(translationX: -256, y: -256)
                
//            case 3:
//                self.imageView.transform = .identity
                
            case 4:
                // This function creates a CGAffineTransform structure, which you can use (and reuse, if you want) to rotate a coordinate system.
                self.imageView.transform = CGAffineTransform(rotationAngle: .pi)
                
//            case 5:
//                self.imageView.transform = .identity
                
            case 6:
                //  alpha -> 0.0 represents totally transparent and 1.0 represents totally opaque.
                self.imageView.alpha = 0.1
                self.imageView.backgroundColor = .green
            case 7:
                self.imageView.alpha = 1
                self.imageView.backgroundColor = .clear
            default:
                break
            }
        }) { finished in
            sender.isHidden = false
        }
        
        currentAnimation += 1
        if currentAnimation > 7 { currentAnimation = 0 }
    }
    
}

