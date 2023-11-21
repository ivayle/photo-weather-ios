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
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerViewController: ImagePickerViewController?
    var loadingIndicatorViewController: LoadingIndicatorViewController?
    var photoMetaDecoder: PhotoMetaDecoder?
    var photoLibraryAuthorizer: PhotoLibraryAuthorizer?

    var photoMeta: PhotoMeta?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePickerViewController = ImagePickerViewController(presentationController: self, delegate: self)
        self.loadingIndicatorViewController = LoadingIndicatorViewController();
        self.photoMetaDecoder = PhotoMetaDecoder(geocoder: CLGeocoder())
        self.photoLibraryAuthorizer = PhotoLibraryAuthorizer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.photoLibraryAuthorizer?.Authorize()
    }
    
    @IBAction func tapOnSelectPhotoButton(_ sender: UIView) {
        self.imageView.image = nil
        self.imagePickerViewController?.present(from: sender)
    }
}

extension MainViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey : Any]) {
        
        loadingIndicatorViewController?.show(parent: self) {
            self.selectPhotoButton.isEnabled = false
        }
        
        let asset = info[.phAsset] as? PHAsset
        self.photoMeta = PhotoMeta(date: asset?.creationDate, location: asset?.location)
        
        print(asset?.creationDate ?? "None")
        print(asset?.location ?? "None")
        
        if let longitude = self.photoMeta?.location?.coordinate.longitude, let latitude = self.photoMeta?.location?.coordinate.latitude, let date = self.photoMeta?.date {
            let key = "4ce961ad99ad9db11e0baef8caeb6391"
            
            let timeInterval = String(format: "%.0f", date.timeIntervalSince1970)
            
            let request = AF.request("https://api.openweathermap.org/data/3.0/onecall/timemachine?lat=\(latitude)&lon=\(longitude)&dt=\(timeInterval)&units=\("metric")&appid=\(key)")
            
            request.responseDecodable(of: PhotoWeatherMeta.self) { response in
                switch response.result {
                    case .success(let photoWeatherMeta):
                    print(photoWeatherMeta)
                    
                    if let location = self.photoMeta?.location, let data = photoWeatherMeta.data.first, let weatherData = data.weather.first {
                        self.photoMetaDecoder?.getNearbyCity(fromCoordinates: location, completion: { place in
                            if let place {
                                let temp: Int = Int(data.temp)
                                let description: String = weatherData.description
                                let temperatureCelsius = NSString(format:"\(temp)%@" as NSString, "\u{00B0}") as String
                                
                                self.imageView.image = self.drawTextToImage(text: "\(place)  |  \(temperatureCelsius)  |  \(description)" as NSString, image: image!)
                            }
                            
                            self.loadingIndicatorViewController?.hide() {
                                self.selectPhotoButton.isEnabled = true
                            }
                        })
                    }
                    
                    case .failure(let error):
                        print(error)
                }
            }
        } else {
            self.loadingIndicatorViewController?.hide() {
                self.selectPhotoButton.isEnabled = true
            }
            self.imageView.image = image
        }
    }
    
    func drawTextToImage(text: NSString, image: UIImage) -> UIImage? {
        let textColor = UIColor.systemBlue
        let textFont = UIFont(name: "Helvetica Bold", size: image.size.width / 25)
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]
        
        image.draw(in: CGRectMake(0, 0, image.size.width, image.size.height))
        
        let textHeight = text.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any]).height
        let textWidth = text.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any]).width
        
        let overlayRect = CGRect(x: 50, y: image.size.height - textHeight - 150, width: textWidth + 100, height: textHeight + 100)

        UIColor.white.withAlphaComponent(0.5).setFill()
        UIRectFill(overlayRect)

        let textRect = CGRectMake(overlayRect.minX + 50, overlayRect.minY + 50, image.size.width, image.size.height)
        text.draw(in: textRect, withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
