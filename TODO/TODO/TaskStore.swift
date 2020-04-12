//
//  TaskStore.swift
//  TODO
//
//  Created by Meghana on 27/03/20.
//  Copyright © 2020 Meghana. All rights reserved.
//

import Foundation
class TaskStore{
    var tasks = [[Task](),[Task]()]
    
 //MARK:= Add task
    func add(_ task:Task ,at index: Int ,isDone:Bool = false){
        let section = isDone ? 1 : 0
        tasks[section].insert(task, at: index)
    }
    
    
 //MARK:= Remove task
    
    func removeTask(at index:Int,isDone:Bool = false) -> Task{
        let section = isDone ? 1 : 0
        return tasks[section].remove(at: index)
    }
}
