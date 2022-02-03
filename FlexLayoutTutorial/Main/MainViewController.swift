//
//  MainViewController.swift
//  FlexLayoutTutorial
//
//  Created by InKwon Todd Kim on 2022/02/03.
//

import UIKit
import FlexLayout
import PinLayout
import Then

final class MainViewController: BaseViewController<MainView> {
    override init() {
        super.init()
        
        title = "FlexLayout Tutorial"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        mainView.delegate = self
    }
}

extension MainViewController: MainViewDelegate {
    func didSelect(type: Menu) {
        navigationController?.pushViewController(type.viewController, animated: true)
    }
}
