// Name: Tafadzwa Chimbindi
// Course: CIT 352 Mobile App
// Professor: Osborne
//  ToDoItemViewController.swift
//  ToDoList
// Purpose: To Load toDoList items to the page for the user to interact with as well as providing ability
// to delete or create a new item
//  Created by citilab on 3/30/22.
//

import UIKit
import CoreData

class ToDoItemViewController: UIViewController, DueDateViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var btnDueDate: UIButton!
    @IBOutlet weak var swTaskComplete: UISwitch!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var pckPriority: UIPickerView!
    @IBOutlet weak var txtTaskDesc: UITextView!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var btnSave: UIBarButtonItem!
    var itemDueDate: Date?
    let pickerData: [String] = ["Low","Medium","High"]
    var listItem: ToDoItem?
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegate and source for the pckPriority pickerview to the current view controller
        pckPriority.delegate = self
        pckPriority.dataSource = self
        
        if listItem != nil {
            // The toDoItem object is received from the ToDoItemTableviewController and
            // the table cell labels will be populated with that objects data
            sgmtEditMode.selectedSegmentIndex = 0
            txtTaskName.text = listItem!.taskName
            txtTaskDesc.text = listItem?.taskDesc
            let itemPriority: Int = Int(listItem!.taskPriority)
            pckPriority.selectRow(itemPriority, inComponent:0, animated: false)
            let dateFormatter:DateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy"
            lblDueDate.text = dateFormatter.string(from: listItem!.dueDate! as Date)
            itemDueDate = listItem!.dueDate as Date?
            swTaskComplete.setOn(listItem!.taskComplete, animated: false)
        } else {
            // There is no toDoItem received from the ToDoItemTableviewController, so the segmented control will be set to view mode so that the user is able to input data into the fields to create a new listItem
            sgmtEditMode.selectedSegmentIndex = 1
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            itemDueDate = Date()
            lblDueDate.text = dateFormatter.string(from: itemDueDate!)
            swTaskComplete.setOn(false, animated: false)
        }
        // Do any additional setup after loading the view.
        changeEditMode(self)
    }
    
    // Implement protocol from DueDateViewController
    // this is a delegate for the DateViewController. if the date has changed
    // then the due date in the string field must be updated and the new
    // date stored in itemDueDate
    func dateChanged(_dueDate: Date) {
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        lblDueDate.text = dateFormatter.string(from: _dueDate)
        itemDueDate = _dueDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueDueDate") {
            // if the segue is to the date picker, pass the date to DateViewController
            let destination = segue.destination as! DueDateViewController
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            itemDueDate = dateFormatter.date(from: lblDueDate.text!)
            destination.dueDate = itemDueDate
            // set the delegate of the destination view controller to self
            destination.delegate = self
        }
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        //depending on the selection made in segmented control, set whether the fields are active (can be edited) or inactive (cannot be edited)
        if sgmtEditMode.selectedSegmentIndex == 0 {
            // Each field is disabled and the border is set with the displayed button
            txtTaskName.isUserInteractionEnabled = false
            txtTaskName.borderStyle = UITextField.BorderStyle.none
            txtTaskDesc.isUserInteractionEnabled = false
            pckPriority.isUserInteractionEnabled = false
            btnDueDate.isHidden = true
            btnSave.isEnabled = false
            swTaskComplete.isUserInteractionEnabled = false
        } else {
            // Each field is enabled and the border is set with the displayed button
            txtTaskName.isUserInteractionEnabled = true
            txtTaskName.borderStyle = UITextField.BorderStyle.roundedRect
            txtTaskDesc.isUserInteractionEnabled = true
            pckPriority.isUserInteractionEnabled = true
            btnDueDate.isHidden = false
            btnSave.isEnabled = true
            swTaskComplete.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func saveItem(_ sender: Any) {
        //set up for save to core data
        let context = appDelegate?.persistentContainer.viewContext
        
        //if no item was passed in, a new one needs to be created
        if listItem == nil {
            listItem = ToDoItem(context: context!)
        }
        
        //item's values must be updated
        listItem!.taskName = txtTaskName.text
        listItem!.taskDesc = txtTaskDesc.text
        listItem!.taskPriority = Int16(pckPriority.selectedRow(inComponent: 0))
        listItem!.taskComplete = swTaskComplete.isOn
        listItem!.dueDate = itemDueDate as Date?
        
        //save to core data
        appDelegate?.saveContext()
        
        //set up to return to View Mode
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    //Specify there is one component for the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Specify the number of elements to be loaded into the pckPriority pickerview
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    //Load the pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //retrieve the pickerView row number selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
}

