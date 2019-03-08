//
//  ReportDetails.swift
//  AssignmentOne
//
//  Created by Jahan on 06/03/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


var tick: Bool?

class ReportDetails: UIViewController, MFMailComposeViewControllerDelegate {
    
    var desReportDetail: techReport?
    
    var initViewController: UITableViewController?
    
    @IBOutlet weak var lblAuthor,lblTitle, lblMoreDetail: UILabel!
    @IBOutlet weak var btnFullReport: UIButton!
    @IBOutlet weak var btnEmailAuthor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If nothing is avaliable then hide button
        desReportDetail?.pdf == nil ? (btnFullReport.isHidden = true) : (btnFullReport.isHidden = false)
        desReportDetail?.email == nil ? (btnFullReport.isHidden = true) : (btnFullReport.isHidden = false)
        
        lblAuthor.text = desReportDetail?.authors ?? "No author"
        lblTitle.text = desReportDetail?.title ?? "No Title"
        
        let str = desReportDetail?.abstract?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        lblMoreDetail.text = str ?? "No text"
    }
    
    
    @IBAction func switchFav(_ sender: UISwitch) {
        // send fav back to viewController class
        
        tick = false
        
        if (sender.isOn == true) {
            tick = true
        }
        else {
            tick = false
        }
        
        initViewController!.tableView.reloadData()
        
    }
    
    @IBAction func btnFullReport(_ sender: Any) {
        UIApplication.shared.open((desReportDetail?.pdf)!) // Opens PDF
    }
    
    @IBAction func btnEmailAuthor(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() { // If device can send an email
            let mail = MFMailComposeViewController() // Instance used for sending an email
            mail.mailComposeDelegate = self  // Mail view controller to compose the email
            
            present(mail, animated: true)
        }
        else { print("error") } // TODO: maybe add return here, need to test
    }
    
    func mailComposeController( _ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        controller.dismiss(animated: true)
    }
}
