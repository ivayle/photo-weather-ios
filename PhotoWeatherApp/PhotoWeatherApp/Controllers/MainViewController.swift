//
//  MainViewController.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import UIKit
import Photos
import Alamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func tapOnSelectPhotoButton(_ sender: UIView) {
        self.imageView.image = nil
        self.imagePickerViewController?.present(from: sender)
    }
    
    var imagePickerViewController: ImagePickerViewController?
    var loadingIndicatorViewController: LoadingIndicatorViewController?
    var photoLibraryAuthorizer: PhotoLibraryAuthorizer?
    var photoWeatherAPIService: PhotoWeatherAPIService?
    var photoImageBuilder: PhotoImageBuilder?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoImageBuilder = PhotoImageBuilder()
        self.photoLibraryAuthorizer = PhotoLibraryAuthorizer()
        self.loadingIndicatorViewController = LoadingIndicatorViewController();
        self.imagePickerViewController = ImagePickerViewController(presentationController: self, delegate: self)
        self.photoWeatherAPIService = PhotoWeatherAPIService(photoMetaDecoder: PhotoMetaDecoder(geocoder: CLGeocoder()))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.photoLibraryAuthorizer?.Authorize()
    }
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey : Any]) {
        
        loadingIndicatorViewController?.show(parent: self) {
            self.selectPhotoButton.isEnabled = false
        }
        
        if let asset = info[.phAsset] as? PHAsset, let date = asset.creationDate, let location = asset.location {
            photoWeatherAPIService?.requestWeatherInformation(photoMeta: PhotoMeta(date: date, location: location), completion: { result in
                if let image {
                    self.photoImageBuilder?.drawToImage(photoResult: result, photoImage: image) { newImage in
                        self.loadingIndicatorViewController?.hide() {
                            self.selectPhotoButton.isEnabled = true
                        }
                        
                        self.imageView.image = newImage
                    }
                }
            })
        } else {
            self.loadingIndicatorViewController?.hide() {
                self.selectPhotoButton.isEnabled = true
            }
            
            self.imageView.image = image
        }
    }
}
