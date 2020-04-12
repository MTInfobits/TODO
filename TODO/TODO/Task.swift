//
//  Task.swift
//  TODO
//
//  Created by Meghana on 27/03/20.
//  Copyright © 2020 Meghana. All rights reserved.
//

import Foundation

class Task : NSObject ,NSCoding{
        var nm:String?
        var isDone:Bool?
    
    private let namekey = "name"
    private let isDonekey = "isDone"
    
    init(nm:String ,isDone:Bool = false) {
        self.nm = nm
        self.isDone = isDone
    }
    func encode(with acoder: NSCoder) {
        acoder.encode(nm,forKey: namekey)
        acoder.encode(isDone ,forKey:  isDonekey)
    }
    required init?(coder aDecoder: NSCoder) {
        guard let name = aDecoder.decodeObject(forKey: namekey) as? String,
            let isDone  = aDecoder.decodeObject(forKey: isDonekey) as? Bool else{return}
        
        self.nm = name
        self.isDone = isDone
    }
}
