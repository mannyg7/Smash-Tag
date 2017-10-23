//
//  Tweet.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/23/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    
    class func findOrCreateTweet(matching twitterInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.identifier)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Tweet.findOrCreateTweet -- database inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let tweet = Tweet(context: context)
        tweet.unique = twitterInfo.identifier
        tweet.text = twitterInfo.text
        tweet.created = twitterInfo.created as NSDate
        
        return tweet
    }
    
    class func findMentions(matching twitterInfo: Twitter.Tweet, with searchText: String, in context: NSManagedObjectContext)throws -> Tweet {
        do {
            let tweet = try findOrCreateTweet(matching: twitterInfo, in: context)
            for hashtag in twitterInfo.hashtags {
                _ = try? Mention.addTweetToMention(for: tweet, matching: hashtag.keyword, oftype: "Hashtags", with: searchText, in: context)
            }
            for user in twitterInfo.userMentions {
                _ = try? Mention.addTweetToMention(for: tweet, matching: user.keyword, oftype: "Users", with: searchText, in: context)
            }
            let userName = "@" + twitterInfo.user.screenName
            _ = try? Mention.addTweetToMention(for: tweet, matching: userName, oftype: "Users", with: searchText, in: context)
            return tweet
        } catch {
            throw error
        }

    }
}
