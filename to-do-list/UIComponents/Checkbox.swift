//
// Created by Nikolay Eckert on 19.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import UIKit


class Checkbox: UIButton {

    // MARK: --
    // MARK: Constants

    let checkedImage = UIImage(named: "checkbox_checked")! as UIImage
    let uncheckedImage = UIImage(named: "checkbox_unchecked")! as UIImage


    // MARK: --
    // MARK: Properties

    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setBackgroundImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setBackgroundImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }


    // MARK: --
    // MARK: Life cycle

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(checkbox_click(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }


    // MARK: -
    // MARK: Services

    @objc func checkbox_click(sender: UIButton) {
        if sender != self {
            return
        }

        self.isChecked = !self.isChecked
    }


    // MARK: --
    // MARK: Other
}