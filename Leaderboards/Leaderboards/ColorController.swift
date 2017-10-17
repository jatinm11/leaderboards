//
//  ColorController.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 22/09/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import Foundation
import GameKit

struct BackgroundColorProvider {
    let colors = [
        UIColor(red: 222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0), // yellow color
        UIColor(red: 223/255.0, green: 86/255.0, blue: 94/255.0, alpha: 1.0), // red color
        UIColor(red: 239/255.0, green: 130/255.0, blue: 100/255.0, alpha: 1.0), // orange color
        UIColor(red: 77/255.0, green: 75/255.0, blue: 82/255.0, alpha: 1.0), // dark color
        UIColor(red: 105/255.0, green: 94/255.0, blue: 133/255.0, alpha: 1.0), // purple color
        UIColor(red: 85/255.0, green: 176/255.0, blue: 112/255.0, alpha: 1.0), // green color
        UIColor(red: 208/255.0, green: 2/255.0, blue: 27/255.0, alpha: 1.0) // Theme color (red)
    ]
    
    func randomColor() -> UIColor {
        let randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: colors.count)
        return colors[randomNumber]
    }
}

