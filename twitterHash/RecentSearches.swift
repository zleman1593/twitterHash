//
//  RecentSearches.swift
//  twitterHash
//
//  Created by Zackery leman on 3/20/15.
//  Copyright (c) 2015 Zleman. All rights reserved.
//

import Foundation

class RecentSearches {
    
 
    private struct Const {
        static let ValuesKey = "RecentSearches.Values"
        static let ValuesCountKey = "RecentSearches.ValuesCount"
        static let NumberOfSearches = 100
    }
    private let defaults = NSUserDefaults.standardUserDefaults()
    var values: [String] {
        get { return defaults.objectForKey(Const.ValuesKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: Const.ValuesKey) }
    }
    
    var valuesCount: [Int] {
        get { return defaults.objectForKey(Const.ValuesCountKey) as? [Int] ?? [] }
        set { defaults.setObject(newValue, forKey: Const.ValuesCountKey) }
    }
    
    
    func add(search: String) {
    
        var currentSearches = values
        var currentSearchesCounts = valuesCount
        var newCount = 1
        
        if let index = find(currentSearches, search) {
            currentSearches.removeAtIndex(index)
            
            newCount += currentSearchesCounts.removeAtIndex(index)

        }
        currentSearchesCounts.insert( newCount, atIndex: 0)
        currentSearches.insert(search, atIndex: 0)
        while currentSearches.count > Const.NumberOfSearches {
            currentSearches.removeLast()
            currentSearchesCounts.removeLast()
        }
        values = currentSearches
        valuesCount = currentSearchesCounts

    }
    
    
    func removeAtIndex(index: Int) {
        var currentSearches = values
        var currentSearchesCounts = valuesCount
        currentSearches.removeAtIndex(index)
        currentSearchesCounts.removeAtIndex(index)
        values = currentSearches
        valuesCount = currentSearchesCounts
    }
    
    func removeAll(){
        values = []
        valuesCount = []
    }
  
    
}


