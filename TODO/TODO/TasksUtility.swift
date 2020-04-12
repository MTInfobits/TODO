//
//  TasksUtility.swift
//  TODO
//
//  Created by Meghana on 08/04/20.
//  Copyright © 2020 Meghana. All rights reserved.
//

import Foundation

class TasksUtility{
    private static let key = "tasks"
    
    //MARK: - archive
    private static func archive(_ tasks: [[Task]]) -> NSData{
        return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
    }
    
    //MARK: - fetch
    
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? [[Task]] ?? [[]]
    }
    
    //MARK: - save
    static func save(_ tasks: [[Task]]){
        //MARK: -Archive
        let archivedTasks = archive(tasks)
        
        //MARK: -set object for key
        UserDefaults.standard.set(archivedTasks, forKey: key)
        
        UserDefaults.standard.synchronize()
    }
}
