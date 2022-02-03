//
//  DJAViewController.swift
//  FlexLayoutTutorial
//
//  Created by InKwon Todd Kim on 2022/02/03.
//

import UIKit

class DJAViewController: BaseViewController<DJAView> {
    init(type: Menu) {
        super.init()
        
        title = type.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
