//
//  ReportDetails.swift
//  AssignmentOne
//
//  Created by Jahan on 06/03/2019.
//  Copyright © 2019 Jahan. All rights reserved.
//

import Foundation
import UIKit

class ReportDetails: UIViewController {
    
    @IBOutlet weak var lblAuthor,lblTitle, lblMoreDetail: UILabel!

    var desReportDetail: techReport?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblAuthor.text = desReportDetail?.authors ?? "No author"
        lblTitle.text = desReportDetail?.title ?? "No Title"
        lblMoreDetail.text = desReportDetail?.abstract ?? "No text"
        
        
        
    }
}
