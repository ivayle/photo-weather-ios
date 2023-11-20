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
    
    var photoLibraryAuthorizer: PhotoLibraryAuthorizer?
    
    var imagePicker: ImagePicker!
    var imageMetaDecoder: ImageMetaDecoder?
    var imageMeta: ImageMeta?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoLibraryAuthorizer = PhotoLibraryAuthorizer()

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.imageMetaDecoder = ImageMetaDecoder(geocoder: CLGeocoder())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.photoLibraryAuthorizer?.Authorize()
    }
    
    @IBAction func tapOnSelectPhotoButton(_ sender: UIView) {
        self.imagePicker.present(from: sender)
    }
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey : Any]) {
        self.imageView.image = image
        
        let asset = info[.phAsset] as? PHAsset
        self.imageMeta = ImageMeta(date: asset?.creationDate, coordinates: asset?.location)
        
        print(asset?.creationDate ?? "None")
        print(asset?.location ?? "None")
        
        if let coordinates = self.imageMeta?.coordinates {
            imageMetaDecoder?.getNearbyCity(fromCoordinates: coordinates, completion: { location in
                print(location ?? "None")
                
                
            })
        }
    }
}
