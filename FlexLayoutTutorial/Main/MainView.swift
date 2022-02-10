//
//  MainView.swift
//  FlexLayoutTutorial
//
//  Created by InKwon Todd Kim on 2022/02/03.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

class MainView: UIView {
    init() {
        propertyView = PropertyView(demoView: demoView)

        super.init(frame: .zero)
        addSubview(containerView)
        backgroundColor = .white
        
        containerView.flex
            .padding(20)
            .define { (flex) in
                flex.addItem(demoView).width(100%).height(50%)
                flex.addItem(propertyView).width(100%).height(50%)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containerView.pin.all(pin.safeArea)
        containerView.flex.layout()
    }

    private let containerView: UIView = .init(frame: .zero).then {
        $0.backgroundColor = .white
    }
    
    private let demoView: DemoView = .init()
    private let propertyView: PropertyView

}
