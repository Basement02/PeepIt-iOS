//
//  ChatTableView.swift
//  PeepIt
//
//  Created by 김민 on 3/4/25.
//

import UIKit
import SwiftUI

class OtherChatTableViewCell: UITableViewCell {
    static let reuseIdentifier = "OtherChatTableViewCell"

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

class MyChatTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MyChatTableViewCell"

    func configure(with chat: Chat, moreButtonTapped: ((Chat) -> Void)?) {
        contentConfiguration = UIHostingConfiguration {
            MyChatBubbleView(chat: chat, showMoreButtonTapped: moreButtonTapped)
        }
        .margins(.all, .zero)
        .margins(.bottom, 15)
    }
}

class ChatTableViewController: UITableViewController {
    var chats: [Chat] = []
    var showMoreHandler: ((Chat) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            OtherChatTableViewCell.self,
            forCellReuseIdentifier: OtherChatTableViewCell.reuseIdentifier
        )

        tableView.register(
            MyChatTableViewCell.self,
            forCellReuseIdentifier: MyChatTableViewCell.reuseIdentifier
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
        let chat = chats[indexPath.row]

        let cell: UITableViewCell

        if chat.type == .mine {
            let myCell = tableView.dequeueReusableCell(
                withIdentifier: MyChatTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! MyChatTableViewCell
            myCell.configure(with: chat, moreButtonTapped: showMoreHandler)
            cell = myCell
        } else {
            let otherCell = tableView.dequeueReusableCell(
                withIdentifier: OtherChatTableViewCell.reuseIdentifier,
                for: indexPath
            ) as! OtherChatTableViewCell
            otherCell.configure(with: chat, moreButtonTapped: showMoreHandler)
            cell = otherCell
        }

        cell.selectionStyle = .none
        cell.backgroundColor = .clear

        return cell
    }

    func scrollToBottom(animated: Bool = true) {
        guard !chats.isEmpty else { return }
        let lastIndexPath = IndexPath(row: chats.count - 1, section: 0)
        tableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: animated)
    }
}
