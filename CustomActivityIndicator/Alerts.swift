//
//  Alerts.swift
//  CustomActivityIndicator
//
//  Created by Ruben Dias on 06/05/2020.
//  Copyright © 2020 Ruben Dias. All rights reserved.
//

import UIKit

class Alerts {
    
    private var isPresenting = false
    
    static var shared = Alerts()
    
    private var activityIndicatorContentView: UIView?
    private var activityIndicatorBackgroundView: BlurredView?
    private var activityIndicatorStackView: UIStackView?
    private var activityIndicatorTextLabel: UILabel?
    private var activityIndicatorSpinner: UIActivityIndicatorView?
    
    private var keyWindow: UIWindow {
        UIApplication.shared.windows.filter{$0.isKeyWindow}.first!
    }
    
    func presentActivityAlert(title: String, completion: (() -> ())? = nil) {
        if isPresenting { return }
        
        DispatchQueue.main.async { [unowned self] in
            self.isPresenting = true
            
            // background view
            self.activityIndicatorBackgroundView = BlurredView()
            self.activityIndicatorBackgroundView?.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicatorBackgroundView?.alpha = 0
            self.activityIndicatorBackgroundView?.frame = self.keyWindow.frame
            
            // content view
            let width: CGFloat = 0.75 * UIScreen.main.bounds.width
            self.activityIndicatorContentView = UIView()
            self.activityIndicatorContentView?.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicatorContentView?.alpha = 0
            self.activityIndicatorContentView?.clipsToBounds = true
            self.activityIndicatorContentView?.layer.cornerRadius = 12
            self.activityIndicatorContentView?.backgroundColor = UIColor.systemBackground
            
            // constraints
            self.keyWindow.addSubview(self.activityIndicatorBackgroundView!)
            self.keyWindow.addSubview(self.activityIndicatorContentView!)
            NSLayoutConstraint.activate([
                self.activityIndicatorContentView!.widthAnchor.constraint(equalToConstant: width),
                self.activityIndicatorContentView!.centerXAnchor.constraint(equalTo: self.keyWindow.centerXAnchor),
                self.activityIndicatorContentView!.centerYAnchor.constraint(equalTo: self.keyWindow.centerYAnchor),
            ])
            
            // activity title
            self.activityIndicatorTextLabel = UILabel()
            self.activityIndicatorTextLabel?.text = title
            self.activityIndicatorTextLabel?.numberOfLines = 0
            self.activityIndicatorTextLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            self.activityIndicatorTextLabel?.textColor = UIColor.label
            self.activityIndicatorTextLabel?.textAlignment = .center
            
            // activity indicator view
            self.activityIndicatorSpinner = UIActivityIndicatorView()
            self.activityIndicatorSpinner?.color = UIColor.label
            self.activityIndicatorSpinner?.startAnimating()
            
            // stack view
            self.activityIndicatorStackView = UIStackView(arrangedSubviews: [self.activityIndicatorTextLabel!, self.activityIndicatorSpinner!])
            self.activityIndicatorStackView?.translatesAutoresizingMaskIntoConstraints = false
            self.activityIndicatorStackView?.axis = .vertical
            self.activityIndicatorStackView?.spacing = 16
            
            // constraints
            self.activityIndicatorContentView?.addSubview(self.activityIndicatorStackView!)
            NSLayoutConstraint.activate([
                self.activityIndicatorStackView!.topAnchor.constraint(equalTo: self.activityIndicatorContentView!.topAnchor, constant: 24),
                self.activityIndicatorStackView!.bottomAnchor.constraint(equalTo: self.activityIndicatorContentView!.bottomAnchor, constant: -24),
                self.activityIndicatorStackView!.leftAnchor.constraint(equalTo: self.activityIndicatorContentView!.leftAnchor, constant: 16),
                self.activityIndicatorStackView!.rightAnchor.constraint(equalTo: self.activityIndicatorContentView!.rightAnchor, constant: -16),
                self.activityIndicatorStackView!.centerYAnchor.constraint(equalTo: self.activityIndicatorContentView!.centerYAnchor)
            ])
            
            UIView.animate(withDuration: 0.25, animations: {
                self.activityIndicatorBackgroundView?.alpha = 1
                self.activityIndicatorContentView?.alpha = 1
            }) { _ in
                completion?()
            }
        }
    }
    
    func changeActivityAlertTitle(newTitle: String) {
        DispatchQueue.main.async {
            self.activityIndicatorTextLabel?.text = newTitle
        }
    }

    func dismissActivityAlert(message: String, completion: (()->())? = nil) {
        if !self.isPresenting { completion?(); return }
        
        self.activityIndicatorTextLabel?.text = message
        self.activityIndicatorSpinner?.removeFromSuperview()
        self.activityIndicatorSpinner = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [unowned self] in
            UIView.animate(withDuration: 0.25, animations: {
                self.activityIndicatorBackgroundView?.alpha = 0
                self.activityIndicatorContentView?.alpha = 0
            }) { _ in                self.activityIndicatorTextLabel?.removeFromSuperview()
                self.activityIndicatorTextLabel = nil
                self.activityIndicatorStackView?.removeFromSuperview()
                self.activityIndicatorStackView = nil
                self.activityIndicatorContentView?.removeFromSuperview()
                self.activityIndicatorContentView = nil
                self.activityIndicatorBackgroundView?.removeFromSuperview()
                self.activityIndicatorBackgroundView = nil
                
                self.isPresenting = false
                completion?()
            }
        }
    }
}
