//
//  ViewController.swift
//  collectioViewExpandableInIOS
//
//  Created by vipin kumar on 10/20/20.
//  Copyright © 2020 vipin kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var currentSection: Int = 0
    var currentRow: Int = 0
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    static var homeArray = [Home]()
    
    var myCurrentImage: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.delegate = self
        collectionView.dataSource = self
        
        ViewController.homeArray.append(Home(homeName: "Sharma Niwass", person: [Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default")), Person(name: "", age: "", gender: "male", image: #imageLiteral(resourceName: "default")), Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default"))], expanded: true))
        ViewController.homeArray.append(Home(homeName: "Chaudhary Niwass", person: [Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default")), Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default")), Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default"))], expanded: true))
        ViewController.homeArray.append(Home(homeName: "Chaudhary Niwass", person: [Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default")), Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default"))], expanded: true))
    }


}



extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !ViewController.homeArray[section].expanded {
            return 0
        }
        return ViewController.homeArray[section].person.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.configureCell(person: ViewController.homeArray[indexPath.section].person[indexPath.row], tag: indexPath.row)
        cell.currentSection = indexPath.section
        cell.currentRow = indexPath.row
        cell.collectionView = collectionView
        //cell.delegate = self
        cell.viewController = self
        return cell
    }

    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ViewController.homeArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionReusableView", for: indexPath) as! CollectionReusableView
        
        view.addPersonBtn.tag = indexPath.section
        view.addPersonBtn.setTitle("Add Person", for: .normal)
        view.addPersonBtn.addTarget(self, action: #selector(addPerson(button:)), for: .touchUpInside)
        
        view.button.tag = indexPath.section
        view.button.setTitle(ViewController.homeArray[indexPath.section].homeName, for: .normal)
        view.button.addTarget(self, action: #selector(handle(button:)), for: .touchUpInside)
        return view
    }
    
    @objc func addPerson(button: UIButton) {
        ViewController.homeArray[button.tag].person.append(Person(name: "", age: "", gender: "", image: #imageLiteral(resourceName: "default")))
        collectionView.reloadData()
    }
    
    
    @objc func handle(button: UIButton) {
        
        let section = button.tag
        var indexPaths = [IndexPath]()
        
        for row in ViewController.homeArray[section].person.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = ViewController.homeArray[section].expanded
        ViewController.homeArray[section].expanded = !isExpanded
        
        if isExpanded {
            collectionView.deleteItems(at: indexPaths)
            collectionView.reloadData()
        }else {
            collectionView.insertItems(at: indexPaths)
            collectionView.reloadData()
        }
    }
    
    
    
    
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.size.width

        let height = collectionViewWidth / 2

        return CGSize(width: collectionViewWidth, height: height)
    }


}
