//
//  ViewController.swift
//  NotifyDemo
//
//  Created by Apple on 16/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let text = "NotifyDemo!"
    private var labels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientBackground()
        setupAnimatedLabels()
        startPopcornAnimation()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.lightGray.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupAnimatedLabels() {
        let totalWidth = CGFloat(text.count * 25)
        let startX = (view.bounds.width - totalWidth) / 2
        let centerY = view.center.y
        
        for (index, character) in text.enumerated() {
            let label = UILabel()
            label.text = String(character)
            label.font = UIFont.monospacedSystemFont(ofSize: 30, weight: .bold)
            label.textAlignment = .center
            label.textColor = .white
            label.frame = CGRect(x: startX + CGFloat(index * 25), y: centerY, width: 25, height: 50)
            label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            view.addSubview(label)
            labels.append(label)
        }
    }
    
    private func startPopcornAnimation() {
        for (index, label) in labels.enumerated() {
            let delay = Double(index) * 0.1
            UIView.animate(
                withDuration: 0.6,
                delay: delay,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [],
                animations: {
                    label.transform = .identity
                },
                completion: { _ in
                    if index == self.labels.count - 1 {
                        self.transitionToSecondVC()
                    }
                }
            )
        }
    }
    
    private func transitionToSecondVC() {
        let secondVC = SecondVC()
        secondVC.navigationItem.hidesBackButton = true
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .fade
        transition.subtype = .fromRight
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(secondVC, animated: false)
    }

}
