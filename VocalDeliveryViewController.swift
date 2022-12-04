//
//  VocalDeliveryViewController.swift
//  Pigi
//
//  Created by Christophorus Davin on 12/04/22.
//

import Foundation
import UIKit

class VocalDeliveryViewController: UIViewController
{
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    var selectedGuide : StepModel!
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var dataSources = [
        StepModel(image: "SpeakingPace", title: "Speaking Pace", description: "Learn how to make your voice perfect for presenting your message."),
        StepModel(image: "SpeakingPace", title: "Filler Words", description: "Learn how to make your voice perfect for presenting your message.")
    ]
    
    @IBOutlet weak var descriptionGuide: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = selectedGuide.title
        detailTableView.delegate = self
        detailTableView.dataSource = self

    }
}

extension VocalDeliveryViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "GuideDetailCellID", for: indexPath) as? GuideDetailCell)!
        cell.object = dataSources[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("yang ke click index : \(indexPath.row)")
        self.performSegue(withIdentifier: "detailSegue", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailSegue"){
            let indexPath = self.detailTableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? TableViewDetail
            
            let selectedGuide = dataSources[indexPath.row]
            
            tableViewDetail?.selectedGuide = selectedGuide
            
            self.detailTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}
