//
//  ViewController.swift
//  MatrixCollectionView
//
//  Created by Parthiv Ganguly on 2/5/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var matrixCollectionView: UICollectionView!
    
    private var gridDimension: Int = 8
    
    /// false = 0 = Orange, true = 1 = Black
    private lazy var items: [[Bool]]? = {
        var items: [[Bool]] = []
        for i in 0..<gridDimension {
            var rowItems: [Bool] = []
            for j in 0..<gridDimension {
                rowItems.append(Bool.random())
            }
            items.append(rowItems)
        }
        return items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        gridDimension * gridDimension
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = matrixCollectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCollectionViewCell", for: indexPath)
        let row = indexPath.item / gridDimension
        let col = indexPath.item % gridDimension
        let itemBool = items?[row][col] ?? false
        if itemBool {
            cell.backgroundColor = .black
        } else {
            cell.backgroundColor = .systemOrange
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / Double(gridDimension) - 15
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.item / gridDimension
        let col = indexPath.item % gridDimension
        
        switchCellsToBlack(startingCell: (row, col))
        matrixCollectionView.reloadData()
    }
    
    func switchCellsToBlack(startingCell: (Int,Int)) {
        let row = startingCell.0
        let col = startingCell.1
        let itemBool = items?[row][col] ?? false
        
        if !itemBool {
            items?[row][col] = true
            
            var cellIndicies: [(Int,Int)] = [(row,col)]
            
            if col < gridDimension - 1 {
                cellIndicies.append((row,col+1))
            }
            if col > 0 {
                cellIndicies.append((row,col-1))
            }
            if row < gridDimension - 1 {
                cellIndicies.append((row+1,col))
            }
            if row > 0 {
                cellIndicies.append((row-1,col))
            }
            
            for cellIndex in cellIndicies {
                switchCellsToBlack(startingCell: cellIndex)
            }
        }
    }
}

