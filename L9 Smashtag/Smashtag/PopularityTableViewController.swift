//
//  PopularityTableViewController.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData

class PopularityTableViewController: FetchedResultsTableViewController {
    
    var mention: String? { didSet { updateUI() } }
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        { didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<Mention>?
    
    private func updateUI() {
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<Mention> = Mention.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(
                key: "type",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ),NSSortDescriptor(
                    key: "count",
                    ascending: false
                ), NSSortDescriptor(
                    key: "keyword",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            request.predicate = NSPredicate(format: "count > 1 AND searchText = %@", mention!)
            fetchedResultsController = NSFetchedResultsController<Mention>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "type",
                cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            fetchedResultsController?.delegate = self
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwitterUser Cell", for: indexPath)
        
        if let twitterUser = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = twitterUser.keyword
            let tweetCount = twitterUser.count
            cell.detailTextLabel?.text = "count: \(tweetCount)"
        }
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let identifier = segue.identifier {
            if identifier == "ShowSearchTweets" {
                if let tweettableViewController = segue.destination as? TweetTableViewController,
                    let cell = sender as? UITableViewCell,
                    let txt = cell.textLabel?.text {
                    tweettableViewController.searchText = txt
                }
            }
        }
        
    }
    
    
 

}
