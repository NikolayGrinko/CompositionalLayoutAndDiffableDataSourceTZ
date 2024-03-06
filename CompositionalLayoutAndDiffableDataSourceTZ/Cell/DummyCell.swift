//
//  DummyCell.swift
//  CompositionalLayoutAndDiffableDataSourceTZ
//
//  Created by Николай Гринько on 06.03.2024.
//


import UIKit

class DummyCell: UICollectionViewCell {

	static let reuseIdentifier = "DummyCell"
	
	@IBOutlet weak var textLabel: UILabel!
	
	func configure(with text: String) {
		textLabel.text = "\(text)"
		
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1.0
		layer.cornerRadius = 8
	}


}

