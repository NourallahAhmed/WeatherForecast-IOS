//
//  HourTableViewCell.swift
//  WeatherForecast2
//
//  Created by NourAllah Ahmed on 4/28/22.
//  Copyright © 2022 NourAllah Ahmed. All rights reserved.
//

import UIKit

class HourTableViewCell: UITableViewCell   {
    
    
    
    
   
    

    @IBOutlet weak var myCollectionView: UICollectionView!
    
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        //based on the hourly array count
//            return 24
//       }
//
//       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionCell", for: indexPath) as! HourlyCollectionViewCell
//
//        cell.myImageView.image = UIImage(named: "default.png")
//        cell.hourLabel.text = "test"
//        cell.tempLabel.text = "text"
//        return cell
//       }
//    override func layoutSubviews() {
//        myCollectionView.dataSource = self
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
