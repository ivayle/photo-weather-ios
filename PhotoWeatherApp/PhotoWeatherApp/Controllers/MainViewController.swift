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
        self.imageView.image = nil
        self.imagePicker.present(from: sender)
    }
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey : Any]) {
        
        loadingIndicator.show(parent: self)
        
        let asset = info[.phAsset] as? PHAsset
        self.imageMeta = ImageMeta(date: asset?.creationDate, location: asset?.location)
        
        print(asset?.creationDate ?? "None")
        print(asset?.location ?? "None")
        
        if let location = self.imageMeta?.location {
            imageMetaDecoder?.getNearbyCity(fromCoordinates: location, completion: { place in
                print(place ?? "None")
                
                
            })
        }
        
        if let longitude = self.imageMeta?.location?.coordinate.longitude, let latitude = self.imageMeta?.location?.coordinate.latitude, let date = self.imageMeta?.date {
            let key = "4ce961ad99ad9db11e0baef8caeb6391"
            
            let timeInterval = String(format: "%.0f", date.timeIntervalSince1970)
            
            let request = AF.request("https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=\(latitude)&lon=\(longitude)&dt=\(timeInterval)&units=\("metric")&appid=\(key)")
            
            request.responseDecodable(of: ImageLocation.self) { response in
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

// MARK: - ImageLocation
struct ImageLocation: Decodable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let data: [Datum]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case data
    }
}

// MARK: - Datum
struct Datum: Decodable {
    let dt, sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let weather: [Weather]

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather
    }
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main, description, icon: String
}
