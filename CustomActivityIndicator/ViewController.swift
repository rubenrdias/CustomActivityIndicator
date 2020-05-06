//
//  ViewController.swift
//  CustomActivityIndicator
//
//  Created by Ruben Dias on 06/05/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
        Alerts.shared.presentActivityAlert(title: "Loading data...")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.imageView.isHidden = false
            self?.button.isHidden = true
            Alerts.shared.dismissActivityAlert(message: "Finished!")
        }
    }
    
}

