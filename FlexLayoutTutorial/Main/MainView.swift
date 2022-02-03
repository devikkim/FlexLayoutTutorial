//
//  MainView.swift
//  FlexLayoutTutorial
//
//  Created by InKwon Todd Kim on 2022/02/03.
//

import UIKit
import PinLayout
import Then

enum Menu: Int {
    case property
    case count
    
    var title: String {
        switch self {
        case .property: return "Property(direction, justify, alignItems)"
        default : return ""
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .property:
            return DJAViewController(type: self)
        case .count:
            return UIViewController()
        }
    }
}

protocol MainViewDelegate: AnyObject {
    func didSelect(type: Menu)
}

class MainView: UIView {
    weak var delegate: MainViewDelegate?
    
    init() {
        super.init(frame: .zero)
        addSubview(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.pin.size(frame.size)
    }
    
    private lazy var tableView: UITableView = .init().then {
        $0.delegate = self
        $0.dataSource = self
        $0.register(cellType: MenuCell.self)
    }
}

extension UITableView {
    func register<T:UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}

extension MainView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let type = Menu(rawValue: indexPath.row) {
            delegate?.didSelect(type: type)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Menu.count.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(cellType: MenuCell.self, indexPath: indexPath)
        
        cell.textLabel?.text = Menu(rawValue: indexPath.row)?.title ?? ""
        return cell
    }
}

final class MenuCell: UITableViewCell {}
