// Name: Tafadzwa Chimbindi
// Course: CIT 352 Mobile App
// Professor: Osborne
//  DueDateViewController.swift
//  ToDoList
// Purpose: To Load a pickerview which the user can select the dueDate of the toDoItems
//  Created by citilab on 4/7/22.
//

import UIKit

// Similar to an interface
protocol DueDateViewDelegate {
    func dateChanged(_dueDate: Date)
}

class DueDateViewController: UIViewController {
    var dueDate: Date?
    // provides reference to the calling view
    var delegate : DueDateViewDelegate! = nil
    @IBOutlet weak var pckDueDate: UIDatePicker!
    @IBAction func btnSave(_ sender: UIBarButtonItem) {
        // if the save button is hit, pass the new date back to the caller and return
        delegate.dateChanged(_dueDate: pckDueDate.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // set date picker to date value sent from the calling view
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        pckDueDate.setDate(dueDate!, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destination.
         Pass the selected object to the new view controller.
    }
    */

}
