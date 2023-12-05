// Name: Tafadzwa Chimbindi
// Course: CIT 352 Mobile App
// Professor: Osborne
//  ToDoItemTableViewController.swift
//  ToDoList
// Purpose: To specify the way that the toDoItems will be displayed in a table as well as handling
// all of the interactions within the table
//  Created by citilab on 4/12/22.
//

import UIKit
import CoreData

class ToDoItemTableViewController: UITableViewController {
    // an array of toDoItems
    var toDoItems: [ToDoItem]?
    // create variables for coreData
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // This will fetch data from core data and refresh the tableView with that data
        self.loadDataFromCoreData()
        self.tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        //segue for item edit
        if(segue.identifier == "editToDoItem") {
            let destination: ToDoItemViewController = segue.destination as! ToDoItemViewController
            let selectedPath : IndexPath  = self.tableView.indexPathForSelectedRow!
            
            //get the item to edit and set destination variable to it
            let toDoItem : ToDoItem = toDoItems![selectedPath.row]
            destination.listItem = toDoItem
        }
    }
    
    func loadDataFromCoreData() {
        // define the sort column and the sorting direction
        var sortColumn: String
        var sortDirASC: Bool
        //retrieve user preferences
        let userPreferences = UserDefaults.standard
        
        //extract sort field preference and specify associated core data variable
        let sortPref: String = userPreferences.string(forKey: "SortField")!
        if sortPref == "Task Name" {
            sortColumn = "taskName"
        }
        else if sortPref == "Due Date" {
            sortColumn = "dueDate"
        }
        else {
            sortColumn = "taskPriority"
        }
        
        //extract sort direction, set boolean variable for later use
        let sortDirPref: String = userPreferences.string(forKey: "SortDirection")!
        if sortDirPref == "ASC" {
            sortDirASC = true
        }
        else {
            sortDirASC = false
        }
        
        //extract show or not show completed task preference, set boolean variable for later use
        let showCompletedTaskPref: Bool = userPreferences.bool(forKey: "TaskCompleted")
        
        //set up context for core data
        let context = appDelegate?.persistentContainer.viewContext
        
        //build and make core data fetch request
        let request = NSFetchRequest<NSManagedObject>(entityName:"ToDoItem")
        
        let listItemEntity = NSEntityDescription.entity(forEntityName: "ToDoItem", in: context!)
        request.entity = listItemEntity
        
        let sortDescriptor = NSSortDescriptor(key: sortColumn, ascending: sortDirASC)
        request.sortDescriptors = [sortDescriptor]
        
        if !showCompletedTaskPref {
            let taskCompletedPredicate = NSPredicate(format:"taskComplete == false")
            request.predicate = taskCompletedPredicate
        }
        
        do {
            // execute the fetch request and load the the data returned to toDoItems array
            toDoItems = try context?.fetch(request) as! [ToDoItem]?
        } catch {
            // Display the error if the fetch request fails
            print("Error in executeFetchRequest: \(error)")
        }
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a ToDoItemTableViewCell
        let cell: ToDoItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemTableViewCell
        
        //add the disclosure indicator (>)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        //retrieve variables from a toDoItem and load them into the cell
        cell.taskName.text = toDoItems![indexPath.row].taskName
        
        // Sets dueDate to label
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString: String = dateFormatter.string(from: toDoItems![indexPath.row].dueDate! as Date)
        cell.taskDueDate.text = dateString
        
        var priorityString : String
        
        // Based on the priority from the toDoItem, set the priority to the string and
        // display it to the cell
        switch toDoItems![indexPath.row].taskPriority {
        case 0:
            priorityString = "Low"
        case 1:
            priorityString = "Medium"
        case 2:
            priorityString = "High"
        default:
            priorityString = "Meh"
        }
        cell.taskPriority.text = priorityString
        
        if toDoItems![indexPath.row].taskComplete == true {
            // The checkmark is shown if the task is complete, indicating the status to the
            // user
            cell.imgCheckMark.isHidden = false
        }
        else {
            // The checkmark is shown if the task is not complete, indicating the status to the user
            cell.imgCheckMark.isHidden = true
        }
        // return the cell populated with the toDoItem data
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row item from the data source
            let toDoItem: ToDoItem = toDoItems![indexPath.row] as ToDoItem
            //set up context for core data and delete the object from core data
            let context = appDelegate?.persistentContainer.viewContext
            context!.delete(toDoItem)
            do {
                // Update the changes to the databse
                try context!.save()
            }
            catch {
                fatalError("Error saving context: \(error)")
            }
            // reload the data from the database and remove row from table
            loadDataFromCoreData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array,
            //and add a new row to the table view
        }
    }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
