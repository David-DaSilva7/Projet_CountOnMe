//
//  UITextView+Extensions.swift
//  CountOnMe
//
//  Created by David Da Silva on 27/05/2021.
//  Copyright © 2021 Vincent Saluzzo. All rights reserved.
//

import UIKit

extension UITextView {
    func scrollToBottom() {
        let textCount: Int = text.count
        guard textCount >= 1 else { return }
        scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
    }
}
