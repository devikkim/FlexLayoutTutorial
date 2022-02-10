//
//  StepperOptionView.swift
//  FlexLayoutTutorial
//
//  Created by todd.kim on 2022/02/09.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxCocoa
import RxSwift

final class StepperOptionView: UIView {

    init(title: String, defaultCount: Int) {
        currentValue = Double(defaultCount)

        super.init(frame: .zero)
        addSubview(containerView)

        containerView.flex.direction(.row).justifyContent(.spaceBetween)
            .define { (flex) in
                flex.addItem(titleLabel)
                flex.addItem().direction(.row).define { (flex2) in
                    flex2.addItem(statusLabel).marginLeft(10)
                    flex2.addItem(stepper).marginLeft(10)
                }
            }

        titleLabel.text = title
        stepper.value = currentValue

        stepper.rx.value
            .bind { [weak self] in
                self?.currentValue = $0
            }
            .disposed(by: disposeBag)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        containerView.flex.layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private let containerView: UIView = .init()
    private let disposeBag: DisposeBag = .init()

    private var currentValue: Double = 0.0 {
        didSet {
            let previousValue = Int(Double(statusLabel.text ?? "") ?? 0.0)
            isIncrease.onNext(previousValue < Int(currentValue))
            statusLabel.text = "\(Int(currentValue))"
            statusLabel.flex.markDirty()
            containerView.flex.layout()
        }
    }

    private let titleLabel: UILabel = .init().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    private let statusLabel: UILabel = .init().then {
        $0.font = .systemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textColor = .black
        $0.textAlignment = .right
    }

    fileprivate let stepper: UIStepper = .init().then {
        $0.stepValue = 1
        $0.minimumValue = 0
        $0.setDecrementImage($0.decrementImage(for: .normal), for: .normal)
        $0.setIncrementImage($0.incrementImage(for: .normal), for: .normal)
        $0.tintColor = .black
    }

    fileprivate var isIncrease: PublishSubject<Bool> = .init()
}

// MARK: - Internal methods
extension StepperOptionView {
    func reset() {
        stepper.value = 0
        stepper.sendActions(for: .editingChanged)
    }
}

// MARK: - Rx Extension
extension Reactive where Base: StepperOptionView {
    var value: ControlProperty<Double> {
        base.stepper.rx.value
    }

    var isIncrease: Observable<Bool> {
        base.isIncrease.asObservable()
    }
}
