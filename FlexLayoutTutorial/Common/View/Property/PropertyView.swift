//
//  PropertyView.swift
//  FlexLayoutTutorial
//
//  Created by todd.kim on 2022/02/09.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxSwift
import RxCocoa

final class PropertyView: UIView {
    init(demoView: DemoView) {
        self.demoView = demoView
        
        super.init(frame: .zero)
        addSubview(scrollView)
        scrollView.addSubview(containerView)

        containerView.flex.define { (flex) in
            flex.addItem().height(10)
            flex.addItem(itemOption)
            flex.addItem().height(10)
            flex.addItem(directionOption)
            flex.addItem().height(10)
            flex.addItem(justifyContentItemsOption)
            flex.addItem().height(10)
            flex.addItem(alignItemsOption)
            flex.addItem().height(10)
            flex.addItem(wrapItemsOption)
            flex.addItem().height(10)
        }

        bind()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.pin.all()
        containerView.pin.horizontally().top()
        containerView.flex.layout(mode: .adjustHeight)

        scrollView.contentSize = containerView.frame.size
    }

    // MARK: - Private
    private let scrollView: UIScrollView = .init()

    private let containerView: UIView = .init()

    private let demoView: DemoView

    private let disposeBag: DisposeBag = .init()

    private let directionOption: SwitchOptionView = .init(option: .direction)

    private let alignItemsOption: SwitchOptionView = .init(option: .alignItems)

    private let justifyContentItemsOption: SwitchOptionView = .init(option: .justifyContent)

    private let wrapItemsOption: SwitchOptionView = .init(option: .wrap)

    private let itemOption: StepperOptionView = .init(title: "item", defaultCount: 3)
}

// MARK: - Private Methods
extension PropertyView {
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

        wrapItemsOption.rx.selectedOptionIndex
            .subscribe (onNext: { [weak self] index in
                let wrap: Flex.Wrap
                switch index {
                case 1: wrap = .wrap
                case 2: wrap = .wrapReverse
                default: wrap = .noWrap
                }

                self?.demoView.update(wrap: wrap)
        }).disposed(by: disposeBag)

        itemOption.rx.isIncrease.bind { [weak self] in
            $0 ? self?.demoView.addItem() : self?.demoView.removeItem()
        }.disposed(by: disposeBag)
    }
}
