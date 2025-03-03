//
//  PeepModalCollectionViewController.swift
//  PeepIt
//
//  Created by 김민 on 3/2/25.
//

import UIKit
import SwiftUI

/// 미리보기 핍 모달의 CollectionView를 구성할 셀
class PeepCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "PeepPreviewCell"

    func configure(with peep: Peep) {
        contentConfiguration = UIHostingConfiguration {
            PeepPreviewThumbnail(peep: peep)
        }
    }
}

/// 미리보기 핍 모달의 UICollectionView
class PeepModalCollectionViewController: UICollectionViewController {
    var peeps: [Peep] = []
    var centerIdx = 0
    var onSelect: ((Int, CellPosition) -> Void)?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 281, height: 384)
        layout.minimumLineSpacing = 10

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(
            PeepCollectionViewCell.self,
            forCellWithReuseIdentifier: PeepCollectionViewCell.reuseIdentifier
        )

        collectionView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return peeps.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PeepCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! PeepCollectionViewCell

        cell.configure(with: peeps[indexPath.item])
        
        return cell
    }

    override func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let cellWidth = layout.itemSize.width + layout.minimumInteritemSpacing

        let estimatedIndex = scrollView.contentOffset.x / cellWidth

        var index: Int

        if velocity.x > 0 {
            index = Int(ceil(estimatedIndex))
        } else if velocity.x < 0 {
            index = Int(floor(estimatedIndex))
        } else {
            index = Int(round(estimatedIndex))
        }

        index = max(min(collectionView.numberOfItems(inSection: 0) - 1, index), 0)
        centerIdx = index

        let newOffsetX = CGFloat(index) * cellWidth - (scrollView.bounds.width - cellWidth) / 2
        targetContentOffset.pointee = CGPoint(x: newOffsetX, y: 0)
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        let position: CellPosition

        if indexPath.item == centerIdx {
            position = .center
        } else if indexPath.item < centerIdx {
            position = .left
        } else {
            position = .right
        }

        onSelect?(indexPath.item, position)
    }

    func scrollToItem(at index: Int, animated: Bool = true) {
        guard index >= 0, index < peeps.count else { return }
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }
}

/// 셀 위치
enum CellPosition {
    case left
    case center
    case right
}
