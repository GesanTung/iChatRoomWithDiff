//
//  ViewController.swift
//  ChatRoom
//
//  Created by Abner on 2019/6/9.
//  Copyright © 2019 老峰. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var dataSource: UITableViewDiffableDataSource<ChatSection, ChatMessage>?
    var currentSnapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatMessage>()
    var chatController = ChatDataController()
    var hodler: Any?
    static let reuseIdentifier = "reuse-identifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ChatRoom"
        configureTableView()
        configureDataSource()
        updateUI()
    }
}

extension ChatViewController {
        
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ChatViewController.reuseIdentifier)
    }
    
    func configureDataSource() {
        
        hodler = chatController.didChange.sink { [weak self] value in
            guard let self = self else { return }
            self.updateUI()
        }
        
        self.dataSource = UITableViewDiffableDataSource
            <ChatSection, ChatMessage>(tableView: tableView) {
                (tableView: UITableView, indexPath: IndexPath, item: ChatMessage) -> UITableViewCell? in
                
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ChatViewController.reuseIdentifier,
                    for: indexPath)
                let name = item.isME ? item.userName : "\(item.userName)\(indexPath.row)"
                cell.textLabel?.text = "\(name): \(item.msgContent)"
                cell.textLabel?.numberOfLines = 0
                return cell
        }
        self.dataSource?.defaultRowAnimation = .fade
        
    }
    
    func updateUI(animated: Bool = true) {
        
        currentSnapshot = NSDiffableDataSourceSnapshot<ChatSection, ChatMessage>()
        
        let items = chatController.displayMsg
        currentSnapshot.appendSections([.socket])
        currentSnapshot.appendItems(items, toSection: .socket)
        
        self.dataSource?.apply(currentSnapshot, animatingDifferences: animated)
        self.tableView.scrollToRow(at: IndexPath.init(row: currentSnapshot.numberOfItems(inSection: .socket) - 1, section: 0), at: .bottom, animated: true)
    }
}


