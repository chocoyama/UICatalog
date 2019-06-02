//
//  EmojiSelectionView.swift
//  EmojiCollectionView
//
//  Created by Takuya Yokoyama on 2019/06/03.
//  Copyright © 2019 chocoyama. All rights reserved.
//

import UIKit

public protocol EmojiSelectionViewDelegate: class {
    func emojiSelectionView(_ emojiSelectionView: EmojiSelectionView, didSelectedEmoji emoji: String)
}

public class EmojiSelectionView: UIView, XibInitializable {

    @IBOutlet weak var contentsCollectionView: UICollectionView! {
        didSet {
            EmojiItemCollectionViewCell.register(for: contentsCollectionView, bundle: .current)
            contentsCollectionView.dataSource = self
            contentsCollectionView.delegate = self
        }
    }
    @IBOutlet weak var sectionSelectCollectionView: UICollectionView! {
        didSet {
            EmojiSectionCollectionViewCell.register(for: sectionSelectCollectionView, bundle: .current)
            sectionSelectCollectionView.dataSource = self
            sectionSelectCollectionView.delegate = self
        }
    }
    
    public weak var delegate: EmojiSelectionViewDelegate?
    
    private let rowCount: CGFloat = 3
    private var fontSize: CGFloat = .leastNormalMagnitude
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        let itemSize = contentsItemSizeFor(collectionViewHeight: contentsCollectionView.frame.height,
                                   rowCount: rowCount)
        fontSize = itemSize.height * (3 / 5)
    }
}

extension EmojiSelectionView: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == contentsCollectionView {
            return EmojiDataSource.allCases.count
        } else {
            return EmojiDataSource.allCases.count
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contentsCollectionView {
            return EmojiDataSource.allCases[section].values.count
        } else {
            return 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contentsCollectionView {
            return EmojiItemCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .setting(emoji: EmojiDataSource.allCases[indexPath.section].values[indexPath.item],
                         fontSize: fontSize)
        } else {
            return EmojiSectionCollectionViewCell
                .dequeue(from: collectionView, indexPath: indexPath)
                .setting(title: "\(indexPath.section)")
        }
    }
}

extension EmojiSelectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contentsCollectionView {
            let emoji = EmojiDataSource.allCases[indexPath.section].values[indexPath.item]
            delegate?.emojiSelectionView(self, didSelectedEmoji: emoji)
        } else {
            contentsCollectionView.selectItem(at: IndexPath(item: 0, section: indexPath.section),
                                              animated: true,
                                              scrollPosition: UICollectionView.ScrollPosition.left)
        }
    }
}

extension EmojiSelectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == contentsCollectionView {
            return contentsItemSizeFor(collectionViewHeight: collectionView.frame.height,
                                       rowCount: rowCount)
        } else {
            let collectionViewWidth = sectionSelectCollectionView.frame.size.width
            let sectionInset = (sectionSelectCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
            let horizontalInset = sectionInset.left + sectionInset.right
            let width = (collectionViewWidth - horizontalInset) / CGFloat(EmojiDataSource.allCases.count)
            return CGSize(width: width, height: sectionSelectCollectionView.frame.size.height)
        }
    }
    
    private func contentsItemSizeFor(collectionViewHeight: CGFloat, rowCount: CGFloat) -> CGSize {
        let height = collectionViewHeight / rowCount
        let width = height
        return CGSize(width: width, height: height)
    }
}
