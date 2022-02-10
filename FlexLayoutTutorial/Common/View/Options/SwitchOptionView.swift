//
//  SwitchOptionView.swift
//  FlexLayoutTutorial
//
//  Created by InKwon Todd Kim on 2022/02/03.
//

import UIKit
import FlexLayout
import PinLayout
import Then
import RxCocoa
import RxSwift

enum SwitchOption {
    case direction
    case justifyContent
    case alignItems
    case wrap
    case alignContent
    case layoutDirection
}

final class SwitchOptionView: UIView {
    
   init(title: String, switchOptions: [String], defaultIndex: Int) {
        
        super.init(frame: .zero)
        addSubview(containerView)
        
        containerView.flex.direction(.column).justifyContent(.start)
            .define { (flex) in
                flex.addItem(titleLabel).marginBottom(5)
                flex.addItem(segmentedControl).grow(1).shrink(1)
            }
        
        titleLabel.text = title
        titleLabel.flex.markDirty()
        
        initSegmentedControl(switchOptions, defaultIndex)
    }
     
    convenience init(option: SwitchOption) {
        switch option {
        case .direction:
            self.init(
                title: "direction",
                switchOptions: ["column", "colum\nreverse", "row", "row\nreverse"],
                defaultIndex: 0
            )
        case .justifyContent:
            self.init(
                title: "justifyContent",
                switchOptions: ["start", "end", "center", "space\nbetween", "space\naround", "space\nevenly"],
                defaultIndex: 0
            )
            
        case .alignItems:
            self.init(
                title: "alignItems",
                switchOptions: ["stretch", "start", "end", "center", "base\nline"],
                defaultIndex: 0
            )
        case .wrap:
            self.init(
                title: "wrap",
                switchOptions: ["noWrap", "wrap", "wrapReverse"],
                defaultIndex: 0
            )
        case .alignContent:
            self.init(
                title: "alignContent",
                switchOptions: ["start", "end", "center", "space\nbetween", "space\naround"],
                defaultIndex: 0
            )
        case .layoutDirection:
            self.init(
                title: "layoutDirection",
                switchOptions: ["inherit", "ltr", "rtl"],
                defaultIndex: 0
            )
        }
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
    
    private let titleLabel: UILabel = .init().then {
        $0.font = .boldSystemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    fileprivate let segmentedControl: UISegmentedControl = .init().then {
        $0.selectedSegmentTintColor = .white
        $0.setTitleTextAttributes([.foregroundColor: UIColor.black], for: UIControl.State.normal)
    }
    
    private func initSegmentedControl(_ switchOptions: [String], _ defaultIndex: Int) {
        switchOptions.enumerated().forEach {
            segmentedControl.insertSegment(withTitle: $0.element, at: $0.offset, animated: true)
        }
        
        segmentedControl.selectedSegmentIndex = defaultIndex
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).numberOfLines = 0
        UILabel.appearance(whenContainedInInstancesOf: [UISegmentedControl.self]).textAlignment = .center
        segmentedControl.apportionsSegmentWidthsByContent = true
    }
    
}

// MARK: - Rx Extension
extension Reactive where Base: SwitchOptionView {
    var selectedOptionIndex: ControlProperty<Int> {
        base.segmentedControl.rx.selectedSegmentIndex
    }
}
