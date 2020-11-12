//
//  Extensions.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 13/11/20.
//  Copyright © 2020 Jatin Menghani. All rights reserved.
//

import UIKit

class JAMButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton() {
        layer.cornerRadius = 7
    }
}

class JAMBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
}
