//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class Checkbox: UIButton {
    let checkedImage = UIImage(named: "checkbox_checked")! as UIImage
    let uncheckedImage = UIImage(named: "checkbox_unchecked")! as UIImage

    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setBackgroundImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setBackgroundImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(checkbox_click(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }

    @objc func checkbox_click(sender: UIButton) {
        if sender != self {
            return
        }

        UIView.animate(withDuration: 0.2, animations: {
            sender.alpha = 0.5
        }, completion: { (finished) in
            self.isChecked = !self.isChecked
            UIView.animate(withDuration: 0.2, animations: {
                sender.alpha = 1.0
            }, completion: nil)
        })
    }
}