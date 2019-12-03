//
//  ListViewController.swift
//  iOS Interview
//
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.register(TherapistTableViewCell.nib, forCellReuseIdentifier: "TherapistTableViewCell")
            tableView.register(NoTherapistTableViewCell.nib, forCellReuseIdentifier: "NoTherapistTableViewCell")
        }
    }
    
    /// This property can also be injected from outside with Dependency Injection
    private lazy var viewModel = ListViewModel(
        items: try! TherapistInfo.make().therapists, originDate: Date()
    )
    
    @IBAction func sortByGap() {
        viewModel.sorting = .byGap
        tableView.reloadData()
    }
    
    @IBAction func sortByOnDuty() {
        viewModel.sorting = .byDuty
        tableView.reloadData()
        
    }
    @IBAction func sortByStartingSoon() {
        viewModel.sorting = .byStartingDate
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch viewModel.filterItems[indexPath.row] {
        case .data(let item):
            return tableView.dataCell(item)
        case .empty(let item):
            return tableView.emptyCell(item)
        }
    }
}

private extension UITableView {
    
    func dataCell(_ item: ListViewModel.DataItem) -> UITableViewCell {
        let cell = dequeueDataCell()
        cell.render(item)
        return cell
    }
    
    func emptyCell(_ item: ListViewModel.EmptyItem) -> UITableViewCell {
        let cell = dequeueEmptyCell()
        cell.render(item)
        return cell
    }
    
    private func dequeueDataCell() -> TherapistTableViewCell {
        return dequeueReusableCell(withIdentifier: "TherapistTableViewCell") as! TherapistTableViewCell
    }
    
    private func dequeueEmptyCell() -> NoTherapistTableViewCell {
        return dequeueReusableCell(withIdentifier: "NoTherapistTableViewCell") as! NoTherapistTableViewCell
    }
}
