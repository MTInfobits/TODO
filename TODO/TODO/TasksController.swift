//
//  TasksController.swift
//  TODO
//
//  Created by Meghana on 23/03/20.
//  Copyright © 2020 Meghana. All rights reserved.
//

import UIKit

class TasksController:UITableViewController
{
    var taskStore:TaskStore! {
        didSet{
            //MARK: -getdta
            
            taskStore.tasks = TasksUtility.fetch() ?? [[Task]() ,[Task]()]
            
            //MARK: -Reload tableview
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
       
    }
    
    @IBAction func AddItem(_ sender: UIBarButtonItem) {
        
        //MARK: -setting up our alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        
        //MARK: -set up the actions
        
        let addAction = UIAlertAction(title: "Add", style: .default){_ in
            //MARK: -Grab textfield text
            
            guard let name = alertController.textFields?.first?.text else{return}
            
            //MARK: - create Task
            let newTask = Task(nm: name)
            
            //MARK:- add Task
            
            self.taskStore.add(newTask, at: 0)
            
            //MARK: -reload data in tableview
            
            let indexpath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexpath], with: .automatic)
            
            //MARK: -save data
            TasksUtility.save(self.taskStore.tasks)
        }
        addAction.isEnabled = false
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        //MARK: - add the textfield
        alertController.addTextField{ textField in
            
            textField.placeholder = "Enter Item Name"
            textField.addTarget(self, action: #selector(self.handleTextchanged), for: .editingChanged)
            
        }
        
        //MARK: -Add actions
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        
        //MARK:- present
        
        present(alertController, animated: true)
    }
    @objc private func handleTextchanged (_ sender : UITextField){
        //MARK: -grab the alert controller and add action
        guard let alertcontroller = presentedViewController as? UIAlertController,
            let addAction = alertcontroller.actions.first,
            let text = sender.text
            else{return}
        
        //MARK: -enable add action base done if text us empty or contains whitespace
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

//MARK: -Datasource
extension TasksController{
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "TO-DO" : "Done"
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].nm
        return cell
    }
}

//MARK: -Delegate
extension TasksController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil){(action,sourceview,completionHandler) in
            
            //MARK: - Determine whether the task 'isDone'
            guard  let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else{return}
            
            //MARK: - Remove the task from appropriate array
            self.taskStore.removeTask(at: indexPath.row ,isDone: isDone)
            
            //MARK: - Reload tableview
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //MARK:- save data
            TasksUtility.save(self.taskStore.tasks)
            
            //MARK: - Indicate that the action was performed
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "Delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil){(action,sourceview,completionHandler) in
            //MARK: -Toggle that the task is done
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            //MARK: -Remove the task from the array containing todo tasks
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            
            //MARK: -Reload tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //MARK: -Add the task to the array containing done tasks
            self.taskStore.add(doneTask, at: 0,isDone: true)
            
            //MARK: -Reload tableview
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            
            //MARK: - save data
            TasksUtility.save(self.taskStore.tasks)
            
            //MARK: -Indicate the action was performed
            completionHandler(true)
            
        }
        doneAction.image = #imageLiteral(resourceName: "Done")
        doneAction.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}
