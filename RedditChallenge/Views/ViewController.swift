//
//  ViewController.swift
//  RedditChallenge
//
//  Created by Sukanya Yanamala on 3/31/22.
//

import UIKit
import Combine
import RedditFramework

protocol ViewControllerProtocol: AnyObject {
    var viewModel: ViewModelProtocol? { get set }
}

class ViewController: UIViewController, ViewControllerProtocol {

    var viewModel: ViewModelProtocol?
    private var subscribers = Set<AnyCancellable>()
    
    private lazy var refreshAction: UIAction = UIAction { [weak self] _ in
        self?.refreshData()
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl(frame: .zero, primaryAction: refreshAction)
        return refresh
    }()
    
    private lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.prefetchDataSource = self
        tableview.delegate = self
        tableview.register(StoryCell.self, forCellReuseIdentifier: StoryCell.identifier)
        tableview.addSubview(refreshControl)
        tableview.accessibilityIdentifier = "table_view_stories"
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ViewControllerConfigurator.assemblingMVVM(view: self)
        setUpUI()
        setUpBinding()
        
        
    }
    
    private func setUpUI() {
        
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
    }
    
    private func setUpBinding() {
        
        viewModel?
            .publisherStories
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.refreshControl.endRefreshing()
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
        
        viewModel?
            .publisherCache
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
        
        viewModel?.getStories()
        
    }
    
    private func refreshData() {
        print("refreshData")
        viewModel?.forceUpdate()
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.totalRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryCell.identifier, for: indexPath) as! StoryCell
        let row = indexPath.row
        let title = viewModel?.getTitle(by: row)
        let data = viewModel?.getImageData(by: row)
        cell.configureCell(title: title, imageData: data)
        return cell
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let indexes = indexPaths.map { $0.row }
        let total = viewModel?.totalRows ?? 0
        if indexes.contains(total - 1) {
            viewModel?.loadMoreStories()
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}
