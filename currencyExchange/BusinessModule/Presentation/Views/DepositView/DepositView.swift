//
//  DepositView.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import UIKit

class DepositView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var deliveryMethodLabel: UILabel!
    
    @IBOutlet weak var countryLogo: UIImageView!
    
    @IBOutlet weak var countryShortNameLabel: UILabel!
        
    @IBOutlet weak var holderView: UIView!
    
    let nibName = "DepositView"
    
    @IBOutlet weak var yourDepostView: UIView!
    
    @IBOutlet weak var exchangeRateView: UIView!
    
    @IBOutlet weak var topViewHolder: UIView!
    
    @IBOutlet weak var bottomLayerView: UIView!
    
    @IBOutlet weak var exchangeButton: UIButton!
    
    @IBOutlet weak var excahngeRateText: UILabel!
    
    @IBOutlet weak var deliveryCountryImage: UIImageView!
    
    @IBOutlet weak var deliveryCountryName: UILabel!
    
    @IBOutlet weak var deliveryStackClickStack: UIStackView!
    
    @IBOutlet weak var deliveryTextfField: UITextField!
    
    @IBOutlet weak var deliveryMethodField: UITextField!
    
    var changeHandler:(()->())?

    
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

        deliveryTextfField.keyboardType = .numberPad
        deliveryMethodField.keyboardType = .numberPad

        topViewHolder.setRadiusCorner(radius: 8)
        topViewHolder.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)
        
        bottomLayerView.setRadiusCorner(radius: 8)
        bottomLayerView.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)

        exchangeButton.tintColor = ColorUtils.greenColor
        exchangeButton.setRadiusCorner(radius:16,color: ColorUtils.lightGreenColor)
        
        exchangeRateView.setRadiusCorner(radius: 12)
        exchangeRateView.setLayer(borderWidth: 0.3)
        exchangeRateView.isHidden = true
        exchangeRateView.backgroundColor = ColorUtils.lightGrayColor
        excahngeRateText.textColor = ColorUtils.grayColor
        deliveryCountryImage.setRadiusCorner(radius: deliveryCountryImage.frame.width/2)
        countryLogo.setRadiusCorner(radius: countryLogo.frame.width/2)

    }
    
    
    func updateExchangeLable(amount:Double, currency:String){
        excahngeRateText.text = "1 AED = \(String(format: "%.2f", amount)) \(currency)"
    }
    
    @IBAction func changeAction(_ sender: Any) {
        if let inputText = deliveryTextfField.text, !inputText.isEmpty {
            deliveryMethodField.text = deliveryTextfField.text
        }
        if let handler = changeHandler {
            handler()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    

}
