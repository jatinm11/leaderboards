//
//  PlayerProfileLastFiveTableViewCell.swift
//  Leaderboards
//
//  Created by Jatin Menghani on 04/10/17.
//  Copyright © 2017 Jatin Menghani. All rights reserved.
//

import UIKit

class PlayerProfileLastFiveTableViewCell: UITableViewCell {

    @IBOutlet var match1Label: UILabel!
    @IBOutlet var match2Label: UILabel!
    @IBOutlet var match3Label: UILabel!
    @IBOutlet var match4Label: UILabel!
    @IBOutlet var match5Label: UILabel!
    
    @IBOutlet var match1View: UIView!
    @IBOutlet var match2View: UIView!
    @IBOutlet var match3View: UIView!
    @IBOutlet var match4View: UIView!
    @IBOutlet var match5View: UIView!
    
    
    override func awakeFromNib() {
        match1View.layer.cornerRadius = match1View.frame.width / 2
        match1View.clipsToBounds = true
        match2View.layer.cornerRadius = match1View.frame.width / 2
        match2View.clipsToBounds = true
        match3View.layer.cornerRadius = match1View.frame.width / 2
        match3View.clipsToBounds = true
        match4View.layer.cornerRadius = match1View.frame.width / 2
        match4View.clipsToBounds = true
        match5View.layer.cornerRadius = match1View.frame.width / 2
        match5View.clipsToBounds = true
    }
    
    func updateViewsWith(matches: [Match], player: Player) {
        match1Label.isHidden = true
        match2Label.isHidden = true
        match3Label.isHidden = true
        match4Label.isHidden = true
        match5Label.isHidden = true
        
        match1View.isHidden = true
        match2View.isHidden = true
        match3View.isHidden = true
        match4View.isHidden = true
        match5View.isHidden = true
        
        for (index, match) in matches.enumerated() {
            if match.winner.recordID == player.recordID {
                switch index {
                case 0:
                    match1Label.text = "W"
                    match1Label.isHidden = false
                    match1View.isHidden = false
                case 1:
                    match2Label.text = "W"
                    match2Label.isHidden = false
                    match2View.isHidden = false
                case 2:
                    match3Label.text = "W"
                    match3Label.isHidden = false
                    match3View.isHidden = false
                case 3:
                    match4Label.text = "W"
                    match4Label.isHidden = false
                    match4View.isHidden = false
                case 4:
                    match5Label.text = "W"
                    match5Label.isHidden = false
                    match5View.isHidden = false
                default:
                    break
                }
            } else {
                switch index {
                case 0:
                    match1Label.text = "L"
                    match1View.backgroundColor = UIColor.red
                    match1View.isHidden = false
                    match1Label.isHidden = false
                case 1:
                    match2Label.text = "L"
                    match2View.backgroundColor = UIColor.red
                    match2View.isHidden = false
                    match2Label.isHidden = false
                case 2:
                    match3Label.text = "L"
                    match3View.backgroundColor = UIColor.red
                    match3View.isHidden = false
                    match3Label.isHidden = false
                case 3:
                    match4Label.text = "L"
                    match4View.backgroundColor = UIColor.red
                    match4View.isHidden = false
                    match4Label.isHidden = false
                case 4:
                    match5Label.text = "L"
                    match5View.backgroundColor = UIColor.red
                    match5View.isHidden = false
                    match5Label.isHidden = false
                default:
                    break
                }
            }
        }
    }
    
}
