//
//  MenuSettingViewController.swift
//  UICatalog
//
//  Created by Takuya Yokoyama on 2018/10/21.
//  Copyright © 2018 Takuya Yokoyama. All rights reserved.
//

import UIKit

protocol MenuSettingViewControllerDelegate: class {
    func menuSettingViewController(_ menuSettingViewController: MenuSettingViewController,
                                   didCommitMenus menus: [Menu])
}

class MenuSettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var delegate: MenuSettingViewControllerDelegate?
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.isEditing = true
            MenuSettingTableViewCell.register(for: tableView, bundle: .current)
        }
    }
    
    private var menus: [Menu]
    
    init(menus: [Menu]) {
        self.menus = menus
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
        self.menus = menus
            .enumerated()
            .compactMap { deleteRows.contains($0.offset) ? nil : $0.element }
        tableView.deleteRows(at: deleteIndexes, with: .automatic)
    }
    
    @IBAction func didTappedDoneButton(_ sender: UIBarButtonItem) {
        delegate?.menuSettingViewController(self, didCommitMenus: menus)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MenuSettingTableViewCell
            .dequeue(from: tableView, indexPath: indexPath)
            .configure(title: menus[indexPath.row].title)
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !menus[indexPath.row].pinned
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !menus[indexPath.row].pinned
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        menus.insert(menus.remove(at: sourceIndexPath.item), at: destinationIndexPath.item)
    }
}
