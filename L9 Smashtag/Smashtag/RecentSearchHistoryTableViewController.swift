//
//  RecentSearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/11/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class RecentSearchHistoryTableViewController: UITableViewController {

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentSearchHistory.recentSearches.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recent Search", for: indexPath) as UITableViewCell
        cell.textLabel?.text = RecentSearchHistory.recentSearches[indexPath.row]
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "Show Searches",
                let tweetTableView = segue.destination as? TweetTableViewController,
                let searchTVCell = sender as? UITableViewCell
            {
                tweetTableView.searchText = searchTVCell.textLabel?.text
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("here")
            RecentSearchHistory.removeSearch(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }

}
