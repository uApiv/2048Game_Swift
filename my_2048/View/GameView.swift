//
//  GameView.swift
//  my_2048
//
//  Created by Pan Xingyuan on 2020/11/25.
//  Copyright © 2020 Pan Xingyuan. All rights reserved.
//

import UIKit

protocol GameViewDelegate {
    func slideEnded(offset: CGPoint)
}

class GameView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: GameViewDelegate? = nil
    private var startLocation = CGPoint()
    var size: Int = 0
    private let margin: CGFloat = 5.0
    private var touchingDetectable = true
    
    private var drawBound: CGRect {
        var bound = self.bounds
        bound.origin.x += margin; bound.origin.y += margin
        bound.size.width -= margin * 2; bound.size.height -= margin * 2
        return bound
    }
    
    private var boundSize: CGFloat {
        let viewWidth = drawBound.size.width
        return viewWidth / CGFloat(size)
    }
    
    private var cardSize: CGSize {
        return CGSize(width: boundSize - margin * 2, height: boundSize - margin * 2)
    }
    
    private func getRectOf(row: Int, col: Int) -> CGRect {
        var location = CGPoint(x: CGFloat(col) * boundSize, y: CGFloat(row) * boundSize)
        location.x += margin + drawBound.origin.x
        location.y += margin + drawBound.origin.y
        return CGRect(origin: location, size: cardSize)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor(red:0.80, green:0.75, blue:0.71, alpha:1.00).setFill()
        for row in 0..<size {
            for col in 0..<size {
                let rect = UIBezierPath(
                    roundedRect: getRectOf(row: row, col: col),
                    cornerRadius: 10.0
                )
                rect.fill()
            }
        }
    }
    
    func performActions(_ actions: [Action]) {
        for action in actions {
            switch action {
            case .new(let position, let newValue):
                newCard(at: position, withValue: newValue)
            case .move(let from, let to):
                moveCard(from: from, to: to)
            case .upgrade(let from, let to, let newValue):
                upgrade(from: from, to: to, newValue: newValue)
            case .success:
                success()
            case .failure:
                failure()
            default:
                break
            }
        }
    }
    
    func success() {
        let alertView = UIAlertView()
        alertView.title = "Win"
        alertView.message = "You win"
        alertView.addButton(withTitle: "Cancel")
        alertView.show()
    }
    
    func failure() {
        let alertView = UIAlertView()
        alertView.title = "Defeat"
        alertView.message = "You lost..."
        alertView.addButton(withTitle: "Cancel")
        alertView.show()
    }
    
    private func getCardView(at position: Position) -> CardView? {
        return viewWithTag(tag(at: position)) as? CardView
    }
    
    private func tag(at position: Position) -> Int {
        return (1 + position.row) * 100 + position.col
    }
    
    private func newCard(at position: Position, withValue value: Int) {
        if let cardView = getCardView(at: position) {
            cardView.flash(withValue: value)
        } else {
            let newCardView = CardView(
                frame: getRectOf(row: position.row, col: position.col),
                value: value
            )
            newCardView.tag = tag(at: position)
            addSubview(newCardView)
            newCardView.createAnimation()
        }
    }
    
    private func moveCard(from: Position, to: Position, completion: (() -> Void)? = nil) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.06 * Double((max(abs(from.row - to.row), abs(from.col - to.col)))),
            delay: 0,
            options: [],
            animations: {
                if let cardView = self.getCardView(at: from) {
                    cardView.frame = self.getRectOf(row: to.row, col: to.col)
                    cardView.tag = self.tag(at: to)
                }
            }) { position in
                completion?()
            }
        
    }
    
    private func upgrade(from: Position, to: Position, newValue: Int) {
        moveCard(from: from, to: to) {
            if let cardView = self.getCardView(at: to) {
                cardView.removeFromSuperview()
            }
            self.newCard(at: to, withValue: newValue)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            startLocation = touch.preciseLocation(in: self)
        }
    }
    
    private func distance(between pointA: CGPoint, and PointB: CGPoint) -> Double {
        return sqrt(Double((pointA.x - PointB.x) * (pointA.x - PointB.x) + (pointA.y - PointB.y) * (pointA.y - PointB.y)))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchingDetectable {
            return
        }
        if let touch = touches.first {
            let endLocation = touch.preciseLocation(in: self)
            if distance(between: endLocation, and: startLocation) > 50 {
                touchingDetectable = false
                let offset = endLocation - startLocation
                delegate?.slideEnded(offset: offset)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touchingDetectable {
            if let touch = touches.first {
                let endLocation = touch.preciseLocation(in: self)
                let offset = endLocation - startLocation
                delegate?.slideEnded(offset: offset)
            }
        } else {
            touchingDetectable = true
        }
    }
    
}

extension CGPoint {
    public static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}
