//
//  CardView.swift
//  my_2048
//
//  Created by Pan Xingyuan on 2020/11/25.
//  Copyright © 2020 Pan Xingyuan. All rights reserved.
//

import UIKit

class CardView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private let label = UILabel()
    private var value: Int = 0 {
        didSet {
            if value == 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
                
                self.backgroundColor = .orange
                label.text = "\(value)"
                label.textColor = .white
            }
        }
    }
    
    init(frame: CGRect, value: Int) {
        super.init(frame: frame)
        self.frame = frame
        self.backgroundColor = .orange
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10.0
        set(value: value)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func updateValue(to newValue: Int) {
        value = newValue
    }
    
    private func set(value: Int) {
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36.0)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor)
            ])
        updateValue(to: value)
        
    }
    
    func createAnimation() {
        transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.1,
            delay: 0.0,
            options: [],
            animations: {
                self.transform = .identity
        }
        )
    }
    
    func flash(withValue value: Int = 0) {
        transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        updateValue(to: value)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.08,
            delay: 0.0,
            options: [.repeat],
            animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }
        ) { position in
            self.transform = .identity
        }
        
    }
}
