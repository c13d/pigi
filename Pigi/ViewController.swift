//
//  ViewController.swift
//  Pigi
//
//  Created by Chrismanto Natanail Manik on 03/04/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    var dataSources = [
        StepModel(image: "VocalDelivery", title: "Vocal Delivery", description: "Articulation is important. Learn how to deliver your ways of thinking!")
    ]
    
    /*
     Draft DataSource
     StepModel(image: "EngageAudience", title: "Engage Audience", description: "Learn to draw your audiences’ attention, only to you!"),
     StepModel(image: "BodyPostureAndGesture", title: "Body Posture and Gesture", description: "Articulation is important. Learn how to deliver your ways of thinking!"),
     StepModel(image: "HowToCalmOurNerves", title: "How To Calm Our Nerves", description: "Learn to draw your audiences’ attention, only to you!"),
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "StepCellID", for: indexPath) as? StepCell)!
        cell.object = dataSources[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("yang ke click index : \(indexPath.row)")
        self.performSegue(withIdentifier: "guideSegue", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "guideSegue"){
            let indexPath = self.tableView.indexPathForSelectedRow!
            
            let tableViewDetail = segue.destination as? VocalDeliveryViewController
            
            let selectedGuide = dataSources[indexPath.row]
            
            tableViewDetail?.selectedGuide = selectedGuide
            
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

