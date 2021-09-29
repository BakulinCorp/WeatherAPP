//
//  WeatherCollectionViewCell.swift
//  Weather
//
//  Created by Максим Бакулин on 14.09.2021.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    static let identifier = "WeatherCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "WeatherCollectionViewCell",
                     bundle: nil)
    }
    
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    
    
    func configure(with model: Current) {
        self.tempLabel.text = "\(Int(model.temp))"
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.image = UIImage(named: "clear")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }


//    static let identifier = "WeatherCollectionViewCell"
//
//    static func nib() -> UINib {
//        return UINib(nibName: "WeatherCollectionViewCell",
//                     bundle: nil)
//    }


}
