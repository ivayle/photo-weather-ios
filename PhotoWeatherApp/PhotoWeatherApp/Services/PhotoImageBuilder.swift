//
//  PhotoImageBuilder.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import Foundation
import UIKit

class PhotoImageBuilder {

    private let padding: CGFloat = 50
    private let startingCoordinateX: CGFloat = 0
    private let startingCoordinateY: CGFloat = 0
    private let textFontRatioToImage: CGFloat = 25

    private let celsiusSign: String = "\u{00B0}"
    private let font: String = "Helvetica Bold"
    private let overlayColor: UIColor = UIColor.white.withAlphaComponent(0.8)
    private let textColor: UIColor = UIColor.systemBlue

    func drawToImage(photoResult: PhotoWeatherResult, image: UIImage, completion: @escaping (UIImage?) -> ()) {
        let place = photoResult.place
        let temperature = photoResult.temperature
        let description = photoResult.description
        let temperatureCelsius = NSString(format:"\(temperature)%@" as NSString, celsiusSign) as String
        let textTemplate = "\(place)  |  \(temperatureCelsius)  |  \(description)"
        let textFont = UIFont(name: self.font, size: image.size.width / textFontRatioToImage)
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
        ]
        
        image.draw(in: CGRectMake(startingCoordinateX, startingCoordinateY, image.size.width, image.size.height))
        
        let textHeight = textTemplate.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any]).height
        let textWidth = textTemplate.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any]).width
        
        let overlayRect = CGRect(x: padding, y: image.size.height - textHeight - (3 * padding), width: textWidth + (2 * padding), height: textHeight + (2 * padding))

        overlayColor.setFill()
        UIRectFillUsingBlendMode(overlayRect, .normal)

        let textRect = CGRectMake(overlayRect.minX + padding, overlayRect.minY + padding, image.size.width, image.size.height)
        textTemplate.draw(in: textRect, withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        completion(newImage)
    }
}
