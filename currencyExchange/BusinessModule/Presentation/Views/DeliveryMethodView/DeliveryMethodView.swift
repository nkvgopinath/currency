//
//  DeliveryMethodView.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 29/11/24.
//

import UIKit
   
class DeliveryMethodView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var tileLabel: UILabel!
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var tickButton: UIButton!

    let nibName = "DeliveryMethodView"

    var backHandler:(()->())?

    override  init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(self.nibName, owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        contentView.backgroundColor = ColorUtils.whiteColor
        tileLabel.textColor = ColorUtils.blackColor
        
        typeImageView.setRadiusCorner(radius: typeImageView.frame.width / 2.0)
        typeImageView.backgroundColor = ColorUtils.lightGreenColor
        tickButton.tintColor = ColorUtils.greenColor
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    

}
