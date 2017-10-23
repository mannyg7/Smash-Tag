//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTweetTableViewController: TweetTableViewController {

    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]) {
        print("starting database load")
        container?.performBackgroundTask { [weak self] context in
            for twitterInfo in tweets {
                if let searchTxt = self?.searchText {
                    _ = try? Tweet.findMentions(matching: twitterInfo, with: searchTxt, in: context)
                }
            }
            try? context.save()
            print("done loading database")
//            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
//                if Thread.isMainThread {
//                    print("on main thread")
//                } else {
//                    print("off main thread")
//                }
//                // bad way to count
//                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count {
//                    print("\(tweetCount) tweets")
//                }
//                 good way to count
                if let tweeterCount = try? context.count(for: Tweet.fetchRequest()) {
                    print("\(tweeterCount) Twitter users")
                }
                
            }
        }
    }

//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "Tweeters Mentioning Search Term" {
//            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController {
//                tweetersTVC.mention = searchText
//                tweetersTVC.container = container
//            }
//        }
//    }

}
