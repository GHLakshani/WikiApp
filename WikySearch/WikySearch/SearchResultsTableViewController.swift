//
//  SearchResultsTableViewController.swift
//  WikySearch
//
//  Created by Digital-06 on 9/21/19.
//  Copyright © 2019 Supun Srilal-COBSCComp171p-005. All rights reserved.
//

import UIKit
import SwiftyJSON
import SafariServices
import Alamofire

class SearchResultsTableViewController: UITableViewController{
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let apiFetcher = APIRequestFetcher()
    private var previousRun = Date()
    private let minInterval = 0.05
    
    private var searchResults = [JSON]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableViewBackgroundView()
        fetchResults(for: "Google")
    }
    
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Wiky search"
        navigationItem.searchController = searchController
        tableView.tableHeaderView = searchController.searchBar
    }
    
    private func setupTableViewBackgroundView() {
        let backgroundViewLabel = UILabel(frame: .zero)
        backgroundViewLabel.textColor = .gray
        backgroundViewLabel.numberOfLines = 0
        backgroundViewLabel.textAlignment = .center
        backgroundViewLabel.text = "Oops, /n No results to show! ..."
        tableView.backgroundView = backgroundViewLabel
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
       return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wikycell",
                                                 for: indexPath) as! CustomTableViewCell
        
        cell.titleView.text = searchResults[indexPath.row]["title"].stringValue
        
        cell.desView.text = searchResults[indexPath.row]["terms"]["description"][0].string
        
        if let url =
            searchResults[indexPath.row]["thumbnail"]["source"].string {
                apiFetcher.fetchImage(url: url, completionHandler: {
                    image, _ in
                    cell.imageView?.image = image
            })
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = searchResults[indexPath.row]["title"].stringValue
        guard let url = URL.init(string: "https://en.wikipedia.org/wiki/\(title)")
            else { return }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SearchResultsTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResults.removeAll()
        guard let textToSearch = searchBar.text, !textToSearch.isEmpty else {
            return
        }
        
        if Date().timeIntervalSince(previousRun) > minInterval {
            previousRun = Date()
            fetchResults(for: textToSearch)
        }
    }
    
    func fetchResults(for text: String) {
        print("Text Searched: \(text)")
        apiFetcher.search(searchText: text, completionHandler: {
            [weak self] results, error in
            if case .failure = error {
                return
            }
            
            guard let results = results, !results.isEmpty else {
                return
            }
            
            print("Results of \(text)", results)
            self?.searchResults = results
        })
    }
}
