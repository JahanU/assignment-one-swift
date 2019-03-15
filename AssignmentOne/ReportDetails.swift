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

class ReportDetails: UIViewController {
    
    var desReportDetail: techReport? // Stores the report that was passed from view controller
    
    @IBOutlet weak var switchFav: UISwitch!
    @IBOutlet weak var lblAuthor, lblTitle, lblMoreDetail: UILabel!
    @IBOutlet weak var btnFullReport, btnEmailAuthor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If nothing is avaliable then hide button
        (desReportDetail?.pdf == nil) ? (btnFullReport.isHidden = true) : (btnFullReport.isHidden = false)
        (desReportDetail?.email == nil) ? (btnEmailAuthor.isHidden = true) : (btnEmailAuthor.isHidden = false)
        
        lblAuthor.text = desReportDetail?.authors ?? "No author"
        lblTitle.text = desReportDetail?.title ?? "No Title"
        // If HTML is found in text then remove them
        lblMoreDetail.text = desReportDetail?.abstract?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? "No text"
        
        // If report is favourited, then button should be set on
        if PersistenceService.getFavourite(aReport: desReportDetail!) {
            switchFav.setOn(true, animated: true)
        }
        else {
            switchFav.setOn(false, animated: true)
        }
    }
    
    @IBAction func switchFav(_ sender: UISwitch) {
        
        let favReport = FavReport(context: PersistenceService.context) // Access to core data so that we can save entities.
        favReport.id = desReportDetail?.id
        favReport.title = desReportDetail?.title
        favReport.year = desReportDetail?.year
        
        if (sender.isOn) {  // Saving data to favReport entity
            favReport.favourite = true
            PersistenceService.saveContext() // Saves data into a container for core data
        }
        else {
            favReport.favourite = false
            PersistenceService.unFave(aReport: desReportDetail!)
        }
    }
    
    
    @IBAction func btnFullReport(_ sender: Any) {
        UIApplication.shared.open((desReportDetail?.pdf)!) // Opens PDF
    }
    
}
extension ReportDetails: MFMailComposeViewControllerDelegate {
    
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
