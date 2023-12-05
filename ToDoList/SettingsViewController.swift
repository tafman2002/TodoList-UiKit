// Name: Tafadzwa Chimbindi
// Course: CIT 352 Mobile App
// Professor: Osborne
//  SettingsViewController.swift
//  ToDoList
// Purpose: To Load the user settings that specify how the toDoList items will be displayed on the ToDoItemView.
// These settings can be changed by the user on this page
//  Created by citilab on 4/5/22.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{

    // Create widgets that references from settings view controller
    @IBOutlet weak var pckSortItem: UIPickerView!
    @IBOutlet weak var sgmtSortDir: UISegmentedControl!
    @IBOutlet weak var swTaskCompleted: UISwitch!
    let sortByFields: [String] = ["Due Date", "Task Name", "Priority"]
    let userPreferences = UserDefaults.standard
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        // set delegate and source for the picker
        pckSortItem.delegate = self
        pckSortItem.dataSource = self
        
        //retrieve and set preferences
        let sortPref: String = userPreferences.string(forKey: "SortField")!
        let sortPrefIndex = sortByFields.firstIndex(of: sortPref)!
        pckSortItem.selectRow(sortPrefIndex, inComponent:0, animated: false)
        
        let sortDirPref: String = userPreferences.string(forKey: "SortDirection")!
        if sortDirPref == "ASC" {
            // Sets the ascending button in segmented view
            sgmtSortDir.selectedSegmentIndex = 0
        }else {
            // Sets the descending button in segmented view
            sgmtSortDir.selectedSegmentIndex = 1
        }
        
        // Retrieves the boolean value from userPreferences and set the switch state to
        // that value
        let showCompletedTaskPref: Bool = userPreferences.bool(forKey: "TaskCompleted")
        swTaskCompleted.isOn = showCompletedTaskPref
    }
    
    @IBAction func sgmtSortDirChanged(_ sender: Any) {
        if sgmtSortDir.selectedSegmentIndex == 0 {
            // Set the sorting order to ascending
            userPreferences.set("ASC", forKey: "SortDirection")
        } else {
            // Set the sorting order to descending
            userPreferences.set("DESC", forKey: "SortDirection")
        }
        
        // synchronize the settings to the userPreferences
        userPreferences.synchronize()
    }
    
    @IBAction func swShowCompletedTasks(_ sender: Any) {
        // If the switch is turned on, ne wpreference value is stored to preferences
        userPreferences.set(swTaskCompleted.isOn, forKey: "TaskCompleted")
    }
    
    //Specify there is one component for the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Specify the number of elements to be loaded into the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return sortByFields.count
    }
    
    //Load the pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortByFields[row]
    }
    
    //retrieve the pickerView row number selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // if the picker is used, new preference value is stored to preferences
        userPreferences.set(sortByFields[row], forKey: "SortField")
        userPreferences.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
