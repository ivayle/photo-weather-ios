//
//  LoadingIndicatorViewController.swift
//  PhotoWeatherApp
//
//  Created by Ivaylo Petrov on 21.11.23.
//

import UIKit

class LoadingIndicatorViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)

    override func loadView() {
        view = UIView()

        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func show(parent: UIViewController, completion: @escaping () -> ()) {
        parent.addChild(self)
        self.view.frame = parent.view.frame
        parent.view.addSubview(self.view)
        self.didMove(toParent: parent)
        
        spinner.startAnimating()
        completion()
    }
    
    func hide(completion: @escaping () -> ()) {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
        spinner.stopAnimating()
        completion()
    }
}
