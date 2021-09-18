//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Максим Бакулин on 14.09.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }
    
    
}
