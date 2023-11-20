//
//  ViewController.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import UIKit
import Photos

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var geocoder: CLGeocoder?
    var imagePicker: ImagePicker!
    var imageDate: Date?
    var imageLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        geocoder = CLGeocoder()
        
        let status = PHPhotoLibrary.authorizationStatus()

        if status == .notDetermined  {
            PHPhotoLibrary.requestAuthorization({status in
            })
        }
    }
    
    @IBAction func tapOnSelectPhotoButton(_ sender: UIView) {
        self.imagePicker.present(from: sender)
    }
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = image
        
        let asset = info[.phAsset] as? PHAsset
        imageDate = asset?.creationDate
        imageLocation = asset?.location
        
        print(asset?.creationDate ?? "None")
        print(asset?.location ?? "None")
        
        if let location = self.imageLocation {
            geocoder?.reverseGeocodeLocation(location) { placemarks, error in
                print(placemarks?.first?.locality ?? "None")
            }
        }
    }
}
