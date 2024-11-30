//
//  PickerView.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import UIKit

class PickerView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    @IBOutlet weak var placeHolderLabel: UILabel!
    
    @IBOutlet weak var viewHolder: UIView!
    
    @IBOutlet weak var labelHolderView: UIView!
    
    
    let nibName = "PickerView"

    var presentPickerHandler:(()->())?

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
        titleLabel.textColor = ColorUtils.blackColor
        titleLabel.text = "Country"
        placeHolderLabel.textColor = ColorUtils.greenColor
        labelHolderView.setRadiusCorner(radius: 6, color: ColorUtils.lightGreenColor)
        arrowImageView.tintColor = ColorUtils.greenColor
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pickerTap))
        labelHolderView.addGestureRecognizer(gesture)

        
    }
    
    @objc func pickerTap() {
        if let presnt  = presentPickerHandler {
            presnt()
        }
       }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    

}
