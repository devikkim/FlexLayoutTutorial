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
        
        addSubview(containterView)
        
        containterView.flex
            .direction(.column)
            .alignItems(.stretch)
            .justifyContent(.start)
            .define { (flex) in
                items.forEach { (item) in
                    let label = makeItem(item: item)
                    flex.addItem(label)
                }
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containterView.pin.all()
        containterView.flex.layout()
    }
    
    func update(direction: Flex.Direction) {
        containterView.flex.direction(direction).markDirty()
        layout()
    }
    
    func update(alignItems: Flex.AlignItems) {
        containterView.flex.alignItems(alignItems).markDirty()
        layout()
    }
    
    func update(justifyContent: Flex.JustifyContent) {
        containterView.flex.justifyContent(justifyContent).markDirty()
        layout()
    }
    
    func update(wrap: Flex.Wrap) {
        containterView.flex.wrap(wrap).markDirty()
        layout()
    }
    
    func addItem() {
        items.append("item\(items.count + 1)")
        containterView.flex.addItem(makeItem(item: items.last))
        layout()
    }
    
    func removeItem() {
        items.removeLast()
        containterView.flex.markDirty()
        layout()
    }
    
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
    
    private let containterView: UIView = .init(frame: .zero).then {
        $0.backgroundColor = .white
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
   
    private var items: [String] = ["item1", "item2", "item3"]
    
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
