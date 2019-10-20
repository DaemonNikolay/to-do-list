//
// Created by Nikolay Eckert on 21.10.2019.
// Copyright (c) 2019 Nikolay Eckert. All rights reserved.
//

import PopupDialog


extension PopupDialog {
    func backgroundColorMode(userInterfaceStyle: UIUserInterfaceStyle) {
        if userInterfaceStyle == .dark {
            self.view.backgroundColor = .systemGray6
        } else {
            self.view.backgroundColor = .white
        }
    }
}