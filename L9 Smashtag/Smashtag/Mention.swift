//
//  Mention.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter


class Mention: NSManagedObject {
    
    class func findOrCreateMention(matching keyword: String, oftype type: String, with searchText: String, in context: NSManagedObjectContext) throws -> Mention
    {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword LIKE[cd] %@ AND searchText = [cd] %@", keyword, searchText)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Mention.findOrCreateMention -- database inconsistency")
                return matches[0]
            } 
        } catch {
            throw error
        }
        
        let mention = Mention(context: context)
        mention.searchText = searchText
        mention.type = type
        mention.keyword = keyword
        mention.count = 0
        return mention
    }
    
    static func addTweetToMention(for tweet: Tweet, matching keyword: String, oftype type: String, with searchText: String, in context: NSManagedObjectContext) throws -> Mention
    {
        do {
            let mention = try findOrCreateMention(matching: keyword, oftype: type, with: searchText, in: context)
            if let tweetSet = mention.tweets as? Set<Tweet>, !tweetSet.contains(tweet) {
                mention.count = Int32((mention.count) + 1)
                mention.addToTweets(tweet)
            }
            return mention
        }catch {
            throw error
        }

    }
}
