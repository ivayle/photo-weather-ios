//
//  PhotoWeatherAPIService.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation
import CoreLocation
import Alamofire

class PhotoWeatherAPIService {
    var photoMetaDecoder: PhotoMetaDecoder
    
    init(photoMetaDecoder: PhotoMetaDecoder) {
        self.photoMetaDecoder = photoMetaDecoder
    }
 
    func requestWeatherInformation(photoMeta: PhotoMeta, completion: @escaping (PhotoWeatherResult) -> ()) {
        
        let timeInterval = String(format: "%.0f", photoMeta.date.timeIntervalSince1970)
        let request = AF.request("https://\(Constants.WEATHER_API_DOMAIN)\(Constants.WEATHER_API_TIMEMACHINE)?lat=\(photoMeta.latitude)&lon=\(photoMeta.longitude)&dt=\(timeInterval)&units=\("metric")&appid=\(Constants.WEATHER_API_KEY)")
        
        request.responseDecodable(of: PhotoWeatherMeta.self) { response in
            switch response.result {
                case .success(let photoWeatherMeta):
                
                if let location = photoMeta.location, let data = photoWeatherMeta.data.first, let weatherData = data.weather.first {
                    self.photoMetaDecoder.getNearbyCity(fromCoordinates: location, completion: { place in
                        if let place {
                            let temperature: Int = Int(data.temp)
                            let description: String = weatherData.description
                            let main: String = weatherData.main
                            
                            completion(PhotoWeatherResult(place: place, temperature: temperature, main: main, description: description))
                        }
                    })
                }
                
                case .failure(let error):
                    print(error)
            }
        }
    }
}
