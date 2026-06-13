//
//  DetailViewController.swift
//  Cafe
//
//  Created by Mac on 2026/06/12.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var keywordLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var cafe: Cafe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "상세 정보"
        setupStyle()
        setupDetail()
    }
    
    func setupStyle() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.90, alpha: 1.0)

        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textColor = UIColor(red: 0.28, green: 0.18, blue: 0.12, alpha: 1.0)

        addressLabel.font = UIFont.systemFont(ofSize: 15)
        addressLabel.textColor = UIColor.darkGray

        keywordLabel.font = UIFont.systemFont(ofSize: 14)
        keywordLabel.textColor = UIColor(red: 0.55, green: 0.34, blue: 0.18, alpha: 1.0)

        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.0)
        descriptionLabel.numberOfLines = 0

        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true

        mapView.layer.cornerRadius = 14
        mapView.clipsToBounds = true

        navigationController?.navigationBar.tintColor = UIColor(red: 0.35, green: 0.22, blue: 0.14, alpha: 1.0)
    }
    
    func setupDetail() {
        guard let cafe = cafe else {
            return
        }

        nameLabel.text = cafe.name
        addressLabel.text = cafe.address
        descriptionLabel.text = cafe.description
        keywordLabel.text = cafe.keywords.map { "#\($0)" }.joined(separator: " ")
        keywordLabel.textColor = .systemBlue

        imageView.image = UIImage(named: "cafe_default")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        setupMap(cafe: cafe)
    }

    func setupMap(cafe: Cafe) {
        let coordinate = CLLocationCoordinate2D(
            latitude: cafe.latitude,
            longitude: cafe.longitude
        )

        let mapRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )

        mapView.setRegion(mapRegion, animated: true)

        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = cafe.name
        annotation.subtitle = cafe.address

        mapView.addAnnotation(annotation)
    }
}
