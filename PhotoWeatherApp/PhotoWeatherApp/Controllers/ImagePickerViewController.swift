//
//  ImagePicker.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 20.11.23.
//

import Foundation
import UIKit

public protocol ImagePickerDelegate: AnyObject {
    func didSelect(image: UIImage?, info: [UIImagePickerController.InfoKey: Any])
}

class ImagePickerViewController: NSObject {

    private let pickerController: UIImagePickerController
    private weak var parentController: UIViewController?
    private weak var delegate: ImagePickerDelegate?

    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.parentController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.mediaTypes = ["public.image"]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.parentController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .photoLibrary, title: "Photo Library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }

        self.parentController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: nil, info: [:])
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?, withInfo info: [UIImagePickerController.InfoKey: Any]) {
        controller.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(image: image, info: info)
    }
}

extension ImagePickerViewController: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil, withInfo: info)
        }

        self.pickerController(picker, didSelect: image, withInfo: info)
    }
}

extension ImagePickerViewController: UINavigationControllerDelegate {
}
