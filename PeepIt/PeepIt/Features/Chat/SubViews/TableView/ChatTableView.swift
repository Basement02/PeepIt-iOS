//
//  ChatTableView.swift
//  PeepIt
//
//  Created by 김민 on 3/4/25.
//

import UIKit
import SwiftUI

class ChatTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ChatTableViewCell"

    func configure(with chat: Chat, moreButtonTapped: ((Chat) -> Void)?) {
        contentConfiguration = UIHostingConfiguration {
            ChatBubbleView(chat: chat, showMoreButtonTapped: moreButtonTapped)
        }
        .margins(.all, .zero)
        .margins(.bottom, 15)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}


class ChatTableViewController: UITableViewController {
    var chats: [Chat] = []
    var showMoreHandler: ((Chat) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            ChatTableViewCell.self,
            forCellReuseIdentifier: ChatTableViewCell.reuseIdentifier
        )
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatTableViewCell.reuseIdentifier,
            for: indexPath
        ) as! ChatTableViewCell

        cell.configure(
            with: chats[indexPath.row],
            moreButtonTapped: showMoreHandler
        )
        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        return cell
    }
}
