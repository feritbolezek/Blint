//
//  MoreOptions.swift
//  Blint
//
//  Created by Ferit Bölezek on 12/05/17.
//  Copyright © 2017 Ferit Bölezek. All rights reserved.
//

import Foundation


class MoreOptions {
    
    static var standard: MoreOptions {
        return MoreOptions()
    }
    
    var moreOptions: [MoreOption] {
        return [
            MoreOption(createNewOptionWithName: "Edit information", identifier: "editInfo"),
            MoreOption(createNewOptionWithName: "Privacy policy", identifier: "privacy"),
            MoreOption(createNewOptionWithName: "Terms of use", identifier: "terms"),
            MoreOption(createNewOptionWithName: "Account Settings", identifier: "accSettings"),
            MoreOption(createNewOptionWithName: "Log out", identifier: "logOut")
               ]
    }
    
}

struct MoreOption {
    
    var optionName: String?
    var optionImagePath: String?
    var identifier: String?
    
    init(createNewOptionWithName name: String, optionImagePath: String? = nil, identifier: String) {
        self.optionName = name
        self.optionImagePath = optionImagePath
        self.identifier = identifier
        
    }
    
}
