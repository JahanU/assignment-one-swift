//
//  ViewController.swift
//  AssignmentOne
//
//  Created by Jahan on 27/02/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController  {
    
    @IBOutlet weak var tblReports: UITableView!
    
    var allReports = [[techReport]]() // first array stores years, second year stores the reports associated with them
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        decodeJson()
    }
    
    override func viewWillAppear(_ animated: Bool) { // Reload tableview when back button is pressed
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}


extension ViewController {
    // Gets the title header for each section, by accessing the first array from the 2D which stores the years for every associated report
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allReports[section].first?.year
    }
    // returns the range of years,  so from from 2001 - 2018 (Returns 18 sections)
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allReports.count // returns the count of the first array
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReports[section].count // Gets the count of how many papers there are given the associated year
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "jsonCells", for: indexPath)
        let report = allReports[indexPath.section][indexPath.row] // Stores the report given the section & row
        cell.textLabel?.text = report.title
        cell.detailTextLabel?.text = report.authors
        // If report is favourited within CoreData, then return add checkmark to cell, else no checkmark.
        (PersistenceService.getFavourite(aReport: report)) ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: self) // "showDetail" is the segue connecting both screens together
    }
    
    // Passes the selected section and row to the second screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondClass = segue.destination as? ReportDetails {
            let arrayIndexRow = tblReports.indexPathForSelectedRow?.row
            let arrayIndexSection = tblReports.indexPathForSelectedRow?.section
            secondClass.desReportDetail = allReports[arrayIndexSection!][arrayIndexRow!]
            tableView.deselectRow(at: tblReports.indexPathForSelectedRow!, animated: true) // Little animation touches
        }
    }
}

extension ViewController {
    
    func decodeJson() {
        if let url = URL(string: "https://cgi.csc.liv.ac.uk/~phil/Teaching/COMP228/techreports/data.php?class=techreports2") {
            let session = URLSession.shared

            session.dataTask(with: url) { (data, response, err) in

                guard let jsonData = data else { return }

                do {
                    let decoder = JSONDecoder()
                    let getTechnicalReports = try decoder.decode(technicalReports.self, from: jsonData)
                    let sortedReports = getTechnicalReports.techreports2.sorted(by: {$0.year > $1.year }) // Sorting years from ascending order
                    self.initAllReports(reportsArray: sortedReports)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
                catch let jsonErr {
                    print("Error decoding JSON", jsonErr)
                }
                }
                .resume()
        }
    }
    
    // converts the sorted JSON array into a 2D array orgnasied by the year
    func initAllReports(reportsArray: [techReport]) {
        var count = 0 // Stores the element position of the year array within the 2D array
        allReports = [[techReport]()] // Initalising 2D array to store type techReport
        allReports[0].append(reportsArray[0]) // Appends the first section of reports (2018 reports only)
        
        for i in 1..<reportsArray.count {
            if (reportsArray[i-1].year != reportsArray[i].year) { // If prev reports year is different to current reports year.
                count += 1
                allReports.append([techReport]())
            }
            allReports[count].append(reportsArray[i]) // Adds current report selected to the correct associated year
        }
    }
}

