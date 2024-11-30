//
//  GridCollectionCell.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import UIKit

class GridCollectionCell: UICollectionViewCell {
    
    
    static var identifier:String = "GridCollectionCell"
    
    @IBOutlet weak var tileLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageView.setRadiusCorner(radius: imageView.frame.height / 2.0)

    }

    
}
