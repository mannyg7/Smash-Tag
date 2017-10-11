//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    // outlets to the UI components in our Custom UITableViewCell
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!

    // public API of this UITableViewCell subclass
    // each row in the table has its own instance of this class
    // and each instance will have its own tweet to show
    // as set by this var
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
//        tweetTextLabel?.text = tweet?.text
        tweetTextLabel?.attributedText = setAttributedText(tweet)
        tweetUserLabel?.text = tweet?.user.description
        
        if let tweet = self.tweet,
            let profileImageURL = tweet.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL),
                    profileImageURL == tweet.user.profileImageURL {
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
    
    private func setAttributedText(_ tweet: Twitter.Tweet?) -> NSMutableAttributedString {
        if let tweet = tweet {
            let tweetAttributedText = NSMutableAttributedString(string: tweet.text)
            tweetAttributedText.setMentionColor(tweet.hashtags, color: UIColor.blue)
            tweetAttributedText.setMentionColor(tweet.urls, color: UIColor.red)
            tweetAttributedText.setMentionColor(tweet.userMentions, color: UIColor.orange)
            return tweetAttributedText
        }
        return NSMutableAttributedString(string: "")
    }
}

private extension NSMutableAttributedString {
    func setMentionColor(_ tweetMentions: [Mention], color:UIColor) {
        for m in tweetMentions {
            addAttribute(NSForegroundColorAttributeName, value: color, range: m.nsrange)
        }
    }
}


