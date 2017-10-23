//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/10/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    private var tweetMentions = [MentionValues] ()
    
    private struct MentionValues{
        var mentionArray: [tweetMention]
        var mentionType: String
    }
    
    var tweet: Twitter.Tweet? {
        didSet {
            if let tweet = tweet {
                loadMentions(from: tweet)
                tableView.reloadData()
                title = tweet.user.name
            }
        }
    }
    
    private enum tweetMention {
        case imageMention(URL, Double, String)
        case textMention(String)
    }
    
    private func setImageMentions(_ tMentions: [MediaItem]) -> [tweetMention] {
        var imagesMentions = [tweetMention]()
        for img in tMentions {
            imagesMentions.append(tweetMention.imageMention(img.url, img.aspectRatio, img.description))
        }
        return imagesMentions
    }
    
    private func setTextMentions(_ tMentions: [Twitter.Mention]) -> [tweetMention] {
        var textMentions = [tweetMention]()
        for txt in tMentions {
            textMentions.append(tweetMention.textMention(txt.keyword))
        }
        return textMentions
    }
    
    private func loadMentions(from tweet:Twitter.Tweet) {
        var newMentions = [MentionValues]()
        
        print(tweet.media.count)
        if tweet.media.count > 0 {
            print("here")
            newMentions.append(MentionValues(mentionArray: setImageMentions(tweet.media), mentionType: "Images"))
        }
        
        if tweet.urls.count > 0 {
            newMentions.append(MentionValues(mentionArray: setTextMentions(tweet.urls), mentionType: "URLs"))
        }
        
        if tweet.hashtags.count > 0 {
            newMentions.append(MentionValues(mentionArray: setTextMentions(tweet.hashtags), mentionType: "Hashtags"))
        }
        
        if tweet.userMentions.count > 0 {
            var userMentionsArr = setTextMentions(tweet.userMentions)
            userMentionsArr.append(tweetMention.textMention("@" + tweet.user.screenName))
            newMentions.append(MentionValues(mentionArray: userMentionsArr, mentionType: "Users"))
        } else {
            var userMentionsArr = [tweetMention]()
            userMentionsArr.append(tweetMention.textMention("@" + tweet.user.screenName))
            newMentions.append(MentionValues(mentionArray: userMentionsArr, mentionType: "Users"))
        }
        
        tweetMentions = newMentions
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tweetMentions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetMentions[section].mentionArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetMen = tweetMentions[indexPath.section].mentionArray[indexPath.row]
        switch tweetMen {
        case .imageMention(let url, _, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMention", for: indexPath)
            if let imgMentionCell = cell as?ImageTableViewCell {
                imgMentionCell.imgURL = url
            }
            return cell
        case .textMention(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextMention", for: indexPath)
            cell.textLabel?.text = text
            return cell
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tweetMen = tweetMentions[indexPath.section].mentionArray[indexPath.row]
        switch tweetMen {
        case .imageMention(_, let ratio, _):
            return tableView.bounds.width / CGFloat(ratio)
        case .textMention(_):
            return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tweetMentions[section].mentionType
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "NewSearch",
            let mentionTVCell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: mentionTVCell),
            tweetMentions[indexPath.section].mentionType == "URLs" {
            
            if let urlText = mentionTVCell.textLabel?.text,
                let url = URL(string:urlText) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            return false
            
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "NewSearch",
                let tweetTableView = segue.destination as? TweetTableViewController,
                let mentionTVCell = sender as? UITableViewCell {
                tweetTableView.searchText = mentionTVCell.textLabel?.text
            }
            
            if identifier == "show image",
                let imageView = segue.destination as? ImageViewController,
                let mentionTVCell = sender as? ImageTableViewCell {
                imageView.imageURL = mentionTVCell.imgURL
            }
        }
    }
    
}
