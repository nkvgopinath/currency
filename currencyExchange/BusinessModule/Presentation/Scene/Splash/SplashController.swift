//
//  SplashController.swift
//  currency
//
//  Created by Gopinath Vaiyapuri on 22/11/24.
//

import UIKit

class SplashController: UIViewController {

@IBOutlet weak var splashScreenLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        splashScreenLabel.accessibilityIdentifier = "SplashScreenLabel"


        DispatchQueue.main.asyncAfter(deadline: .now()+5, execute: {
            self.moveToCurrencyScreen()
        })
        

        // Do any additional setup after loading the view.
    }


    private func moveToCurrencyScreen(){
       
        let controller = CurrencyDashBoardController()
        let coordinator = CurrencyCoordinator()
        let repository = CountryRepository(APIClient())
        let viewModel = CurrencyViewModel(coordinator: coordinator, repository: repository)
        controller.viewModel = viewModel
        coordinator.viewController = controller
        self.navigationController?.pushViewController(controller, animated: true)



    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
