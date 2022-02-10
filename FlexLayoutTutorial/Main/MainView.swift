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
        bind()
        
        containerView.flex
            .padding(20)
            .define { (flex) in
                flex.addItem(itemOption).marginBottom(10)
                flex.addItem(demoView).width(100%).height(50%).shrink(1).grow(1).marginBottom(10)
                flex.addItem(removeAllButton).marginBottom(20)
                flex.addItem().direction(.row).alignItems(.center).define { (flex2) in
                    flex2.addItem().height(1).backgroundColor(.lightGray).grow(1)
                    
                    let label: UILabel = .init().then {
                        $0.text = "FlexBox container properties"
                        $0.font = .boldSystemFont(ofSize: 17)
                    }
                    flex2.addItem(label).marginHorizontal(10)
                    
                    flex2.addItem().height(1).backgroundColor(.lightGray).grow(1)
                }
                flex.addItem(propertyView).width(100%).height(50%).marginTop(10)
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
    
    // MARK: - Private property
    private let disposeBag: DisposeBag = .init()
    
    private let demoView: DemoView = .init()
    
    private let propertyView: PropertyView
    
    private let itemOption: StepperOptionView = .init(title: "The number of item", defaultCount: 3)
    
    private let removeAllButton: UIButton = .init().then {
        $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
        $0.setTitle("Remove all items", for: .normal)
        $0.setTitleColor(.systemRed, for: .normal)
        
        $0.layer.cornerRadius = 5
        $0.layer.borderColor = UIColor.systemRed.cgColor
        $0.layer.borderWidth = 0.5
        $0.clipsToBounds = true
    }
}

// MARK: - Private methods
private extension MainView {
    private func bind() {
        itemOption.rx.isIncrease
            .observe(on: MainScheduler.instance)
            .bind { [weak self] in
                $0 ? self?.demoView.addItem() : self?.demoView.removeItem()
            }.disposed(by: disposeBag)
        
        removeAllButton.rx.tap.bind { [weak self] in
            self?.itemOption.reset()
            self?.demoView.removeAll()
        }.disposed(by: disposeBag)
    }
}
