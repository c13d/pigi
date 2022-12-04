//
//  LessonViewController.swift
//  Pigi
//
//  Created by alvin anderson on 12/04/22.
//

import UIKit

class LessonViewController: UIViewController {

    @IBOutlet weak var lessonView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    var datasource = [StepModel(image: "WpmImage", title: "What is Pace?", description: "Pace is the speed at which you speak or how quickly you speak. It's measured in words per minute(WPM)"),
                      StepModel(image: nil, title: "Ideal speaking pace", description: "If you speak too quickly or too slowly, you sound nervous, anxious,and unconfident.If you speak too quickly or too slowly, you sound nervous, anxious,and unconfident.But if you speak so slowly, your audience will get bored and stop paying attention.The ideal speaking pace range for presentation is 100 - 150 words per minute."),
                      StepModel(image: nil, title: "Short story help you put public speaking in perspective", description: "Reading children's stories can develop an adaptive level of speech.Reading children's stories can develop an adaptive level of speech. Let’s focus on your vocal delivery without worrying about what to say.")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: true)

        lessonView.delegate = self
        lessonView.dataSource = self
        // Do any additional setup after loading the view.
    }
    @IBAction func nextPress(_ sender: UIButton) {
        performSegue(withIdentifier: "toMiniPractice", sender: self)
    }
    
    @IBAction func closePress(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)

    }
}

extension LessonViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Lebar & tinggil cell
            return CGSize(width: UIScreen.main.bounds.width, height: 500)
        }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = lessonView.dequeueReusableCell(withReuseIdentifier: "lessonControllerViewCell", for: indexPath) as!LessonCollectionViewCell
        cell.object = datasource[indexPath.row]
        return cell
    }
}
