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
    private let iconSizeRationToImage: CGFloat = 5

    private let celsiusSign: String = "\u{00B0}"
    private let font: String = "Helvetica Bold"
    private let overlayColor: UIColor = UIColor.white.withAlphaComponent(0.8)
    private let overlayTextColor: UIColor = UIColor.systemBlue

    func drawToImage(photoResult: PhotoWeatherResult, photoImage: UIImage, completion: @escaping (UIImage?) -> ()) {
        let place = photoResult.place
        let temperature = photoResult.temperature
        let description = photoResult.description
        let temperatureCelsius = NSString(format:"\(temperature)%@" as NSString, celsiusSign) as String
        let text = "\(place)  |  \(temperatureCelsius)  |  \(description)"
        let textFont = UIFont(name: self.font, size: photoImage.size.width / textFontRatioToImage)
        let iconWidth = photoImage.size.width / iconSizeRationToImage
        let iconHeight = iconWidth / 1.75
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(photoImage.size, false, scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: overlayTextColor,
        ]
        
        let textHeight = text.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any]).height
        let textWidth = text.size(withAttributes: textFontAttributes as [NSAttributedString.Key : Any]).width
        
        photoImage.draw(in: CGRectMake(startingCoordinateX, startingCoordinateY, photoImage.size.width, photoImage.size.height))
        
        let textOverlay = CGRect(x: padding, y: photoImage.size.height - textHeight - (3 * padding), width: textWidth + (2 * padding), height: textHeight + (2 * padding))
        overlayColor.setFill()
        UIRectFillUsingBlendMode(textOverlay, .normal)

        let textRect = CGRectMake(textOverlay.minX + padding, textOverlay.minY + padding, photoImage.size.width, photoImage.size.height)
        text.draw(in: textRect, withAttributes: textFontAttributes as [NSAttributedString.Key : Any])
        
        let iconOverlay = CGRect(x: padding, y: padding, width: iconWidth + (2 * padding), height: iconHeight + (2 * padding))
        overlayColor.setFill()
        UIRectFillUsingBlendMode(iconOverlay, .normal)
        
        let resizedIcon = resize(image: UIImage(named: "CloudyIcon")!, targetSize: CGSize(width: iconWidth, height: iconHeight))
        let coloredIcon = changeStrokes(for: resizedIcon, color: overlayTextColor)
        coloredIcon.draw(in: CGRectMake(iconOverlay.minX + padding, iconOverlay.minY + padding, iconWidth, iconHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        completion(newImage)
    }
    
    private func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
           newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
           newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    private func changeStrokes(for image: UIImage, color: UIColor) -> UIImage {
        return UIGraphicsImageRenderer(size: image.size).image { context in
            color.setFill()
            context.fill(context.format.bounds)
            image.draw(in: context.format.bounds, blendMode: .destinationIn, alpha: 1.0)
        }
    }
}
