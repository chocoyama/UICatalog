//
//  MenuSettingViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/21.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

protocol MenuSettingViewControllerDelegate: class {
    func menuSettingViewController<T>(_ menuSettingViewController: MenuSettingViewController<T>,
                                      didCommitPages pages: [AnyPage<T>])
}

class MenuSettingViewController<T>: UIViewController,
                                    UITableViewDataSource,
                                    UITableViewDelegate {

    weak var delegate: MenuSettingViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.isEditing = true
            MenuSettingTableViewCell.register(for: tableView, bundle: .current)
        }
    }
    
    private var pages: [AnyPage<T>]
    
    init(pages: [AnyPage<T>]) {
        self.pages = pages
        super.init(nibName: "MenuSettingViewController", bundle: .current)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func didTappedDeleteButton(_ sender: UIBarButtonItem) {
        guard let deleteIndexes = tableView.indexPathsForSelectedRows, !deleteIndexes.isEmpty else {
            let alert = UIAlertController(title: nil, message: "削除するアイテムを選択して下さい", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        let deleteRows = deleteIndexes.map { $0.row }
        self.pages = pages
            .enumerated()
            .compactMap { deleteRows.contains($0.offset) ? nil : $0.element }
        tableView.deleteRows(at: deleteIndexes, with: .automatic)
    }
    
    @IBAction func didTappedDoneButton(_ sender: UIBarButtonItem) {
        delegate?.menuSettingViewController(self, didCommitPages: pages)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MenuSettingTableViewCell
            .dequeue(from: tableView, indexPath: indexPath)
            .configure(title: pages[indexPath.row].title)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !pages[indexPath.row].pinned
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !pages[indexPath.row].pinned
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        pages.insert(pages.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
    }
}
