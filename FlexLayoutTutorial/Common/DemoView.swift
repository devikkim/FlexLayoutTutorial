//
//  DemoView.swift
//  FlexLayoutTutorial
//
//  Created by InKwon Todd Kim on 2022/02/03.
//

import UIKit
import FlexLayout
import PinLayout
import Then

class DemoView: UIView {
    init() {
        super.init(frame: .zero)
        addSubview(containerView)
        
        containerView.flex.direction(.column).alignItems(.stretch).justifyContent(.start).define { (flex) in
            items.forEach { (item) in
                flex.addItem(item)
            }
        }

        addItem()
        addItem()
        addItem()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.pin.all()
        containerView.flex.layout()
    }

    // MARK: - Private properties
    private var items: [UILabel] = []
    private var containerView: UIView = .init(frame: .zero).then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
}

// MARK: - Internal methods
extension DemoView {
    func update(direction: Flex.Direction) {
        containerView.flex.direction(direction).markDirty()
        layout()
    }

    func update(alignItems: Flex.AlignItems) {
        containerView.flex.alignItems(alignItems).markDirty()
        layout()
    }

    func update(justifyContent: Flex.JustifyContent) {
        containerView.flex.justifyContent(justifyContent).markDirty()
        layout()
    }

    func update(wrap: Flex.Wrap) {
        containerView.flex.wrap(wrap).markDirty()
        layout()
    }

    func addItem() {
        items.append(makeItem(item: "item\(items.count + 1)"))

        guard let lastItem = items.last else { return }

        containerView.flex.addItem(lastItem)
        layout(animated: false)
    }

    func removeItem() {
        guard items.last != nil else { return }
        items.removeLast().removeFromSuperview()
        layout(animated: false)
    }
}

// MARK: - Private methods
private extension DemoView {
    private func layout(animated: Bool = true) {
        setNeedsLayout()

        if animated {
            UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveEaseInOut
            ) {
                self.layoutIfNeeded()
            }
        }
    }

    private func makeItem(item: String?) -> UILabel {
        .init().then {
            $0.text = item
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.black.cgColor
            $0.backgroundColor = .systemBlue
            $0.textColor = .white
            $0.textAlignment = .center
        }
    }
}
