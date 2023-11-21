//
//  ViewController.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import UIKit
import Photos
import Alamofire

class MainViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let loadingIndicator = SpinnerViewController()
    
    var photoLibraryAuthorizer: PhotoLibraryAuthorizer?
    
    var imagePicker: ImagePicker!
    var photoMetaDecoder: PhotoMetaDecoder?
    var photoMeta: PhotoMeta?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoLibraryAuthorizer = PhotoLibraryAuthorizer()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.photoMetaDecoder = PhotoMetaDecoder(geocoder: CLGeocoder())
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.photoLibraryAuthorizer?.Authorize()
    }
    
    @IBAction func tapOnSelectPhotoButton(_ sender: UIView) {
        self.imageView.image = nil
        self.imagePicker.present(from: sender)
    }
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey : Any]) {
        
        loadingIndicator.show(parent: self)
        
        let asset = info[.phAsset] as? PHAsset
        self.photoMeta = PhotoMeta(date: asset?.creationDate, location: asset?.location)
        
        print(asset?.creationDate ?? "None")
        print(asset?.location ?? "None")
        
        if let location = self.photoMeta?.location {
            photoMetaDecoder?.getNearbyCity(fromCoordinates: location, completion: { place in
                print(place ?? "None")
                
                
            })
        }
        
        if let longitude = self.photoMeta?.location?.coordinate.longitude, let latitude = self.photoMeta?.location?.coordinate.latitude, let date = self.photoMeta?.date {
            let key = "4ce961ad99ad9db11e0baef8caeb6391"
            
            let timeInterval = String(format: "%.0f", date.timeIntervalSince1970)
            
            let request = AF.request("https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=\(latitude)&lon=\(longitude)&dt=\(timeInterval)&units=\("metric")&appid=\(key)")
            
            request.responseDecodable(of: PhotoWeatherMeta.self) { response in
                switch response.result {
                    case .success(let location):
                    print(location)
                    case .failure(let error):
                        print(error)
                }
                
                self.loadingIndicator.hide()
                self.imageView.image = image
            }
        } else {
            self.loadingIndicator.hide()
            self.imageView.image = image
        }
    }
}
