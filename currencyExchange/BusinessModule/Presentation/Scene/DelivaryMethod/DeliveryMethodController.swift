//
//  DeliveryMethodController.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 28/11/24.
//

import UIKit


class DeliveryMethodController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var viewHolder: UIView!

    @IBOutlet weak var bankView: DeliveryMethodView!

    @IBOutlet weak var cashView: DeliveryMethodView!

    @IBOutlet weak var mobileView: DeliveryMethodView!

    
    @IBOutlet weak var emptyView: UIView!

    var viewModel: CurrencyViewModel?
    
    var handleTap:((String)->())?
    
    var selectedType: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHolder.setTopCornerRadius(40)
        bankView.setRadiusCorner(radius: 8)
        cashView.setRadiusCorner(radius: 8)
        mobileView.setRadiusCorner(radius: 8)

        emptyView.addTouchListener(target: self, action: #selector(viewTapped))

        
        bankView.typeImageView.image = UIImage(named: "bank")?.withRenderingMode(.alwaysTemplate)
        bankView.tileLabel.text = "Bank Account"
        bankView.typeImageView.tintColor = ColorUtils.greenColor
        bankView.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)
        
        
        cashView.typeImageView.image = UIImage(named: "cash")?.withRenderingMode(.alwaysTemplate)
        cashView.typeImageView.tintColor = ColorUtils.greenColor
        cashView.tileLabel.text = "Cash Pickup"
        cashView.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)


        mobileView.typeImageView.image = UIImage(named: "wallet")?.withRenderingMode(.alwaysTemplate)
        mobileView.tileLabel.text = "Mobile Wallet"
        mobileView.typeImageView.tintColor = ColorUtils.greenColor
        mobileView.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)


        bankView.addTouchListener(target: self, action: #selector(bankTapped))
        cashView.addTouchListener(target: self, action: #selector(cashTapped))
        mobileView.addTouchListener(target: self, action: #selector(mobileTapped))
        
        
        if selectedType == "Bank"{
            setactActive(uiView:bankView , button: bankView.tickButton)
            setInactive(uiView: cashView, button: cashView.tickButton)
            setInactive(uiView: mobileView, button: mobileView.tickButton)
            
        }else if selectedType == "Cash"{
            setInactive(uiView:bankView , button: bankView.tickButton)
            setactActive(uiView: cashView, button: cashView.tickButton)
            setInactive(uiView: mobileView, button: mobileView.tickButton)

        }else if selectedType == "Wallet"{
            setInactive(uiView:bankView , button: bankView.tickButton)
            setInactive(uiView: cashView, button: cashView.tickButton)
            setactActive(uiView: mobileView, button: mobileView.tickButton)

        }


    }
    
    
    
    func setactActive(uiView: UIView, button: UIButton){
        
        button.isSelected = true
        uiView.setLayer(borderWidth: 1, color: ColorUtils.greenColor)

    }
    
    func setInactive(uiView: UIView, button: UIButton){
        button.isSelected = false
        uiView.setLayer(borderWidth: 0.5, color: ColorUtils.lightGrayColor)

    }
    
    @objc private func bankTapped() {
        setactActive(uiView:bankView , button: bankView.tickButton)
        setInactive(uiView: cashView, button: cashView.tickButton)
        setInactive(uiView: mobileView, button: mobileView.tickButton)
        selectedType = "Bank"
        if let handle = handleTap {
            handle(selectedType)
        }
        
    }
     
    @objc private func cashTapped() {
        setInactive(uiView:bankView , button: bankView.tickButton)
        setactActive(uiView: cashView, button: cashView.tickButton)
        setInactive(uiView: mobileView, button: mobileView.tickButton)
        selectedType = "Cash"

        if let handle = handleTap {
            handle(selectedType)
        }

    }
 
    @objc private func mobileTapped() {
        setInactive(uiView:bankView , button: bankView.tickButton)
        setInactive(uiView: cashView, button: cashView.tickButton)
        setactActive(uiView: mobileView, button: mobileView.tickButton)
        selectedType = "Wallet"

        if let handle = handleTap {
            handle(selectedType)
        }
    }
 

    @objc private func viewTapped() {
        if let handle = handleTap {
            handle(selectedType)
        }
        self.dismiss(animated: true)
    }
 

}

