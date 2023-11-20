//
//  PhotoLibraryAuthorizer.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import Foundation
import Photos

class PhotoLibraryAuthorizer {
    
    func Authorize() {
        let status = PHPhotoLibrary.authorizationStatus()

        if status == .notDetermined  {
            PHPhotoLibrary.requestAuthorization({status in
            })
        }
    }
}
