//
//  RecentSearchHistory.swift
//  Smashtag
//
//  Created by Manmitha Gundampalli on 10/11/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

struct RecentSearchHistory {
    
    static var recentSearches: [String] {
        get {
            if let searchHistory = UserDefaults.standard.object(forKey: "RecentSearchHistory") as? [String] {
                return searchHistory
            }
            return [String]()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "RecentSearchHistory")
        }
    }
    
    static func removeSearch(_ index: Int) {
        var searches = recentSearches
        searches.remove(at: index)
        recentSearches = searches
    }
    
    static func addSearch(_ text: String) {
        if !text.isEmpty {
            var searches = recentSearches.filter{$0.caseInsensitiveCompare(text) != .orderedSame}
            searches.insert(text, at: 0)
            recentSearches = searches
            removeOverHundred()
        }
    }
    
    private static func removeOverHundred() {
        var searches = recentSearches
        if searches.count > 100 {
            searches.removeLast()
        }
        recentSearches = searches
    }
}
