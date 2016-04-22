//
//  InterfaceBuilderInfo.swift
//  Cortex
//
//  Created by Manisha Yeramareddy on 9/17/15.
//  Copyright (c) 2015 Manisha Yeramareddy. All rights reserved.
//

import Foundation

struct InterfaceBuilderInfo {
    
    struct SeguePath {
        static let showCreateNewThoughtView = "showCreateNewThoughtView"
        static let registerView = "showRegisterView"
        static let goToSearchResults = "goToSearchResults"
        static let showSearchResultAttachments = "showSearchResultAttachments"
        static let showDoodleViewSegue = "showDoodleViewSegue"
        static let showSearchedThoughtAttachments = "showSearchedThoughtAttachments"
    }
    
    struct CellIdentifiers {
        static let categoryCell = "categoryCell"
        static let attachmentCell = "attachmentCell"
        static let searchResultCell = "searchResultCell"
        static let historyCell = "historyCell"
        static let changeCategoryCell = "changeCategoryCell"
    }
    
    struct Constants {
        static let MAX_ATT_PER_THOUGHT = 3
        static let DEFAULT_MOOD_VALUE : Int = 4
        static let DEFAULT_LOC_NO_WIFI : Double = 9999.99
    }
    
    struct SearchResultType {
        static let UNKNOWN = -1
        static let DATE = 0
        static let CATEGORY = 1
        static let LOCATION = 2
        static let MOOD = 3
        static let KEYWORD = 4
    }
    
    /*struct SyncStatus {
        static let NEEDS_TO_BE_SYNCED = 1
        static let ALREADY_SYNCED = 0
    }*/
}