//
//  DetectedObjectController.swift
//  DetectionApp
//
//  Created by Brandi Taylor on 9/25/20.
//

import Foundation

class DetectedObjectController {
    
    var detectedObjects: [DetectedObject] = []
//    var detectedObject: DetectedObject?
    
    
    // Create a DetectedObject
    func createDetectedObject(withName name: String) -> DetectedObject {
        
        let detectedObject = DetectedObject(name: name)
        detectedObjects.append(detectedObject)
        saveToPersistence()
        
        return detectedObject
    }
    
    // MARK: - Persistence
    
    // Define URL for file in Documents Directory
    private var detectedObjectsURL: URL? {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return dir.appendingPathComponent("DetectedObjects.plist")
    }
    
    // Load the DetectObjects file
    func loadFromPersistence() {
        let fm = FileManager.default
        
        do {
            guard let url = detectedObjectsURL,
                  fm.fileExists(atPath: url.path) else { return }
                let data = try Data(contentsOf: url)
                let decoder = PropertyListDecoder()
            
            detectedObjects = try decoder.decode([DetectedObject].self, from: data)
            print("Count from persisitence load: ", detectedObjects.count)
        } catch {
            print("Could not load detectedObjects from persistence")
        }
    }
    
    // Save a DetectedObjects to the file
    func saveToPersistence() {
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(detectedObjects)
            guard let url = detectedObjectsURL else { return }
            try data.write(to: url)
        } catch {
            print("Could not save detected to persistence")
        }
    }
}
