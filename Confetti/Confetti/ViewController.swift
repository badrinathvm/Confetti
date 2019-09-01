//
//  ViewController.swift
//  Confetti
//
//  Created by Badrinath on 9/1/19.
//  Copyright © 2019 Badrinath. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let confettiView = ConfettiView(frame: self.view.bounds)
        
        // Set colors (default colors are red, green and blue)
        confettiView.colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                               UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                               UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                               UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                               UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        
        
        // Set intensity (from 0 - 1, default intensity is 0.5)
        confettiView.intensity = 0.7
        
        confettiView.type = ConfettiType.image(UIImage(named: "cone")!)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            confettiView.stopConfetti()
        }
        
        self.view.addSubview(confettiView)
        
        confettiView.startConfetti()
    }
    
}

