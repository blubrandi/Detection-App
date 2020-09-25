//
//  DetectedObjectsTableViewController.swift
//  DetectionApp
//
//  Created by Brandi Taylor on 9/25/20.
//

import UIKit

class DetectedObjectsTableViewController: UITableViewController {
    
    let detectedObjectController = DetectedObjectController()
    var detectedObject: DetectedObject?
//    var detectedObjects: [DetectedObject]?

    override func viewDidLoad() {
        super.viewDidLoad()
        detectedObjectController.loadFromPersistence()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detectedObjectController.detectedObjects.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detectedObjectCell", for: indexPath)

        let detectedObject = detectedObjectController.detectedObjects[indexPath.row]
        cell.textLabel?.text = detectedObject.name

        return cell
    }

}
