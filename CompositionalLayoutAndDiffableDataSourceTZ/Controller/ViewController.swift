//
//  ViewController.swift
//  CompositionalLayoutAndDiffableDataSourceTZ
//
//  Created by Николай Гринько on 06.03.2024.
//

import UIKit

enum Section {
	case main
}


class ViewController: UIViewController, UICollectionViewDelegate {
	
	var currentIndexPath: IndexPath?
	let pressedDownTransform =  CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
	
	// Implementation of a method that takes a cell index and changes it randomly
	var timer = Timer(timeInterval: 3.0, repeats: true) { _ in print("Done!") }
	
	var dataSource: UICollectionViewDiffableDataSource<Section, Int>! = nil
	var collectionView: UICollectionView! = nil
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Nested Groups"
		configureHierarchy()
		collectionView.delegate = self
		configureDataSource()
		
		let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLongPress))
		longPressRecognizer.minimumPressDuration = 0.05
		longPressRecognizer.cancelsTouchesInView = false
		collectionView.addGestureRecognizer(longPressRecognizer)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		DispatchQueue.main.asyncAfter(deadline: .now()+3.0, execute: self.updateCell)
	}
	
	private func updateCell() {
		collectionView.reloadData()
	}
	
	private func configureHierarchy() {
		collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
		collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		collectionView.backgroundColor = .systemBackground
		let nib = UINib(nibName: DummyCell.reuseIdentifier, bundle: nil)
		collectionView.register(nib, forCellWithReuseIdentifier: DummyCell.reuseIdentifier)
		view.addSubview(collectionView)
	}
	
	func createLayout() -> UICollectionViewLayout {
		let layout = UICollectionViewCompositionalLayout {
			(sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
			
			let oneItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let twoItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let threeItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let fourItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let fiveItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let sixItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let sevenItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let eightItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let nineItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let tenItem = NSCollectionLayoutItem(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)))
			
			let bottomNestedGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)),
				subitems: [oneItem, twoItem, threeItem, fourItem, fiveItem, sixItem])
			
			let bottomNestedGroup2 = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)),
				subitems: [sevenItem, eightItem, nineItem, tenItem])
			
			let nestedGroup = NSCollectionLayoutGroup.vertical(
				layoutSize: NSCollectionLayoutSize(widthDimension: .estimated(70),
												   heightDimension: .estimated(70)),
				subitems: [bottomNestedGroup, bottomNestedGroup2])
			
			let section = NSCollectionLayoutSection(group: nestedGroup)
			section.orthogonalScrollingBehavior = .continuous
			return section
		}
		return layout
	}
	
	private func configureDataSource() {
		dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
			(collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
			
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DummyCell.reuseIdentifier, for: indexPath) as? DummyCell else { fatalError("Cannot create the cell") }
			let randomInt = Int.random(in: 0..<110)
			cell.textLabel.text = "\(identifier)"
			cell.textLabel.text = "\(randomInt)"
			return cell
		}
		
		var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
		snapshot.appendSections([.main])
		snapshot.appendItems(Array(0..<110))
		dataSource.apply(snapshot, animatingDifferences: false)
	}
	
	@nonobjc func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
	@objc func didTapLongPress(sender: UILongPressGestureRecognizer) {
		let point = sender.location(in: collectionView)
		let indexPath = collectionView.indexPathForItem(at: point)
		
		// Initial press down, animate inward, keep track of the currently pressed index path
		if sender.state == .began, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
			
			animate(cell, to: pressedDownTransform)
			self.currentIndexPath = indexPath
		} else if sender.state == .changed {
			
			// Touch moved
			// If the touch moved outwidth the current cell, then animate the current cell back up
			// Otherwise, animate down again
			if indexPath != self.currentIndexPath, let currentIndexPath = self.currentIndexPath, let cell = collectionView.cellForItem(at: currentIndexPath) {
				if cell.transform != .identity {
					animate(cell, to: .identity)
				}
			} else if indexPath == self.currentIndexPath, let indexPath = indexPath, let cell = collectionView.cellForItem(at: indexPath) {
				if cell.transform != pressedDownTransform {
					animate(cell, to: pressedDownTransform)
				}
			}
			// Touch ended/cancelled, revert the cell to identity
		} else if let currentIndexPath = currentIndexPath, let cell = collectionView.cellForItem(at: currentIndexPath) {
			
			animate(cell, to: .identity)
			self.currentIndexPath = nil
		}
	}
	
	private func animate(_ cell: UICollectionViewCell, to transform: CGAffineTransform) {
		UIView.animate(withDuration: 0.4,
					   delay: 0,
					   usingSpringWithDamping: 0.4,
					   initialSpringVelocity: 3,
					   options: [.curveEaseInOut],
					   animations: {
			cell.transform = transform
		}, completion: nil)
	}
}

