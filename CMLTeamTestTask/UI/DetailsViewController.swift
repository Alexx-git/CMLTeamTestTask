//
//  DetailsViewController.swift
//  CMLTeamTestTask
//
//  Created by ALEXANDER on 4/22/21.
//  Copyright © 2021 ALEXANDER. All rights reserved.
//

import UIKit
import MapKit
import BoxView

class DetailsViewController: ScrollViewController {
    
    let photoView = SectionView(title: "Photos")
    
    let addressLabel = UILabel()
    
    let locationView = SectionView(title: "Address")
    
    let descriptionLabel = UILabel()
    
    var property: Property
    
    init(property: Property) {
        self.property = property
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = property.name
        
        contentView.insets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0)
        locationView.insets.bottom = 16.0
        contentView.items = [
            descriptionLabel.boxed,
            locationView.boxed,
            photoView.boxed,
        ]
        descriptionLabel.numberOfLines = 0
        if let attrDesc = property.description.htmlToAttributedString {
            descriptionLabel.attributedText = attrDesc
        }
        else {
            descriptionLabel.text = property.description
        }
                
        locationView.addText(property.address())
        locationView.addMapCoordinate(latitude: property.coordinates.lat, longitude: property.coordinates.lng)
        
        property.imageS3Array.forEach {
            NetworkManager.shared.loadImage(urlString: $0.temporaryLink) { (image, error) in
                guard !self.handleError(error) else { return }
                self.photoView.addImage(image)
            }
        }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back_button"), style: .plain, target: self, action: #selector(backButtonClick))
        self.navigationItem.leftBarButtonItem?.tintColor = .white

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.contentInset.bottom = 0
    }

    @objc func backButtonClick() {
        navigationController?.popViewController(animated: true)
    }

}

class SectionView: BoxView {
    let label = UILabel()
    
    convenience init(title: String?) {
        self.init(spacing: 4.0)
        label.font = .boldSystemFont(ofSize: 18.0)
        label.text = title
    }

    override func setup() {
        super.setup()
        items = [label.boxed.bottom(8.0).top(8.0)]
        spacing = 4.0
    }
    
    func addText(_ text: String?) {
        if let text = text {
            let label = UILabel()
            label.text  = text
            addItem(label.boxed)
        }
    }
    
    func addImage(_ image: UIImage?) {
        if image != nil {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            if let size = image?.size {
                imageView.pinAspectFromSize(size)
            }
            
            imageView.image = image
            addItem(imageView.boxed.centerX())
        }
        print("items: \(items)")
    }
    
    func addMapCoordinate(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) {
        if let latitude = latitude, let longitude = longitude {
            let mapView = MKMapView()
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            mapView.setCenter(coordinate, animated: false)
            addItem(mapView.boxed.height(200.0))
        }
    }
}
