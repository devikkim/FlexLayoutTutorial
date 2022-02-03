//
//  DJAView.swift
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

class DJAView: UIView {
    init() {
        super.init(frame: .zero)
        addSubview(containerView)
        backgroundColor = .white
        
        containerView.flex
            .padding(20)
            .justifyContent(.spaceBetween)
            .define { (flex) in
                flex.addItem(demoView).width(100%).height(50%)
                flex.addItem().define { (flex2) in
                    let label = UILabel().then {
                        $0.text = "Properties"
                        $0.font = .boldSystemFont(ofSize: 17)
                    }
                    flex2.addItem(label)
                    flex2.addItem().height(10)
                    flex2.addItem(directionOption)
                    flex2.addItem().height(10)
                    flex2.addItem(justifyContentItemsOption)
                    flex2.addItem().height(10)
                    flex2.addItem(alignItemsOption)
                    flex2.addItem().height(10)
                }
        }
        
        bind()
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
    
    private let disposeBag: DisposeBag = .init()
    
    private let directionOption: SwitchOptionView = .init(option: .direction)
    
    private let alignItemsOption: SwitchOptionView = .init(option: .alignItems)
    
    private let justifyContentItemsOption: SwitchOptionView = .init(option: .justifyContent)
    
    private func bind() {
        directionOption.rx.selectedOptionIndex
            .subscribe (onNext: { [weak self] index in
                let direction: Flex.Direction
                switch index {
                case 1: direction = .columnReverse
                case 2: direction = .row
                case 3: direction = .rowReverse
                default: direction = .column
                }
                
                self?.demoView.update(direction: direction)
        }).disposed(by: disposeBag)
        
        alignItemsOption.rx.selectedOptionIndex
            .subscribe (onNext: { [weak self] index in
                let alignItem: Flex.AlignItems
                switch index {
                case 1: alignItem = .start
                case 2: alignItem = .end
                case 3: alignItem = .center
                case 4: alignItem = .baseline
                default: alignItem = .stretch
                }
                
                self?.demoView.update(alignItems: alignItem)
        }).disposed(by: disposeBag)
        
        justifyContentItemsOption.rx.selectedOptionIndex
            .subscribe (onNext: { [weak self] index in
                let justifyContent: Flex.JustifyContent
                switch index {
                case 1: justifyContent = .end
                case 2: justifyContent = .center
                case 3: justifyContent = .spaceBetween
                case 4: justifyContent = .spaceAround
                case 5: justifyContent = .spaceEvenly
                default: justifyContent = .start
                }
                
                self?.demoView.update(justifyContent: justifyContent)
        }).disposed(by: disposeBag)
        
    }
}
