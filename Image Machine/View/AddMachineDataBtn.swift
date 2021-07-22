//
//  AddMachineDataBtn.swift
//  Image Machine
//
//  Created by Mauldy Putra on 22/07/21.
//

import UIKit

class AddMachineDataBtn: UIView {
    weak var context: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(context: UIViewController) {
        self.init()
        self.context = context
        self.initLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initLayer() {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 340, y: 650, width: 48, height: 48)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.tintColor = .white
        button.backgroundColor = UIColor.rgb(red: 1, green: 117, blue: 226)
        button.contentMode = .center
        button.layer.cornerRadius = button.frame.height / 2
        button.addTarget(self, action: #selector(didTapped), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let trailingConstraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.context?.view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -20)
        let bottomConstraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.context?.view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -100)
        
        let widthConstraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 48)
        let heightConstraints = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 48)
        
        self.context?.view.addSubview(button)
        self.context?.view.addConstraints([trailingConstraints, bottomConstraints, widthConstraints, heightConstraints])
    }
    
    @objc func didTapped() {
        
    }
}
