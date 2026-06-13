//
//  ViewController.swift
//  Cafe
//
//  Created by Mac on 2026/06/12.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var selectLabel: UILabel!
    @IBOutlet weak var cafeListTitleLabel: UILabel!
    @IBOutlet weak var regionPickerView: UIPickerView!
    @IBOutlet weak var cafeStackView: UIStackView!
    
    var cafes: [Cafe] = []
    var regions: [String] = []
    var selectedRegion: String = ""
    var selectedCafe: Cafe?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "지역별 카페 추천"

        regionPickerView.delegate = self
        regionPickerView.dataSource = self

        setupText()
        setupStyle()
        loadCafeData()
        setupRegions()
        updateCafeList()
    }

    func setupText() {
        titleLabel.text = "지역별 카페 추천"
        selectLabel.text = "지역을 선택하세요"
        cafeListTitleLabel.text = "추천 카페"
    }
    
    func setupStyle() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.95, blue: 0.90, alpha: 1.0)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.textColor = UIColor(red: 0.28, green: 0.18, blue: 0.12, alpha: 1.0)
        titleLabel.textAlignment = .center

        selectLabel.font = UIFont.systemFont(ofSize: 16)
        selectLabel.textColor = UIColor.darkGray
        selectLabel.textAlignment = .center

        cafeListTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        cafeListTitleLabel.textColor = UIColor(red: 0.35, green: 0.22, blue: 0.14, alpha: 1.0)

        regionPickerView.backgroundColor = UIColor.white
        regionPickerView.layer.cornerRadius = 12
        regionPickerView.layer.masksToBounds = true

        cafeStackView.spacing = 12

        navigationController?.navigationBar.tintColor = UIColor(red: 0.35, green: 0.22, blue: 0.14, alpha: 1.0)
    }
    
    func loadCafeData() {
        guard let url = Bundle.main.url(forResource: "cafeData", withExtension: "json") else {
            print("cafeData.json 파일을 찾을 수 없습니다.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            cafes = try JSONDecoder().decode([Cafe].self, from: data)
        } catch {
            print("JSON 파싱 오류:", error)
        }
    }

    func setupRegions() {
        var tempRegions: [String] = []

        for cafe in cafes {
            if !tempRegions.contains(cafe.region) {
                tempRegions.append(cafe.region)
            }
        }

        regions = tempRegions

        if let firstRegion = regions.first {
            selectedRegion = firstRegion
        }
    }

    func updateCafeList() {
        cafeStackView.arrangedSubviews.forEach { view in
            cafeStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        cafeListTitleLabel.text = "\(selectedRegion) 추천 카페"

        let filteredCafes = cafes.filter { $0.region == selectedRegion }

        for cafe in filteredCafes {
            let rowView = createCafeRow(cafe: cafe)
            cafeStackView.addArrangedSubview(rowView)
        }
    }

    func createCafeRow(cafe: Cafe) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false

        let nameLabel = UILabel()
        nameLabel.text = cafe.name
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let addressLabel = UILabel()
        addressLabel.text = cafe.address
        addressLabel.font = UIFont.systemFont(ofSize: 13)
        addressLabel.textColor = .darkGray
        addressLabel.numberOfLines = 2
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        let keywordLabel = UILabel()
        keywordLabel.text = cafe.keywords.map { "#\($0)" }.joined(separator: " ")
        keywordLabel.font = UIFont.systemFont(ofSize: 12)
        keywordLabel.textColor = UIColor(red: 0.55, green: 0.34, blue: 0.18, alpha: 1.0)
        keywordLabel.numberOfLines = 2
        keywordLabel.translatesAutoresizingMaskIntoConstraints = false

        let detailButton = UIButton(type: .system)
        detailButton.setTitle("상세", for: .normal)
        detailButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        detailButton.addTarget(self, action: #selector(detailButtonTapped(_:)), for: .touchUpInside)

        if let index = cafes.firstIndex(where: { $0.name == cafe.name && $0.address == cafe.address }) {
            detailButton.tag = index
        }

        containerView.addSubview(nameLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(keywordLabel)
        containerView.addSubview(detailButton)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 95),

            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -8),

            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            addressLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            addressLabel.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -8),

            keywordLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            keywordLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            keywordLabel.trailingAnchor.constraint(equalTo: detailButton.leadingAnchor, constant: -8),
            keywordLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10),

            detailButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            detailButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            detailButton.widthAnchor.constraint(equalToConstant: 50)
        ])

        containerView.backgroundColor = UIColor.white
        containerView.layer.cornerRadius = 14
        containerView.layer.borderWidth = 0.5
        containerView.layer.borderColor = UIColor(red: 0.85, green: 0.78, blue: 0.70, alpha: 1.0).cgColor

        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        
        return containerView
    }
    @objc func detailButtonTapped(_ sender: UIButton) {
        selectedCafe = cafes[sender.tag]
        performSegue(withIdentifier: "showDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let detailVC = segue.destination as? DetailViewController {
                detailVC.cafe = selectedCafe
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return regions.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return regions[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRegion = regions[row]
        updateCafeList()
    }
}
