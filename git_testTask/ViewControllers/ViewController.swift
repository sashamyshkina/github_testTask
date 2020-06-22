//
//  ViewController.swift
//  GitHub_testTask
//
//  Created by Sasha Myshkina on 18.06.2020.
//  Copyright © 2020 Sasha Myshkina. All rights reserved.
//

import UIKit
import ProgressHUD

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultsCollection: UICollectionView!
    
    var repositaryPresenter: RepositoryPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
    }
    
    private func prepare() {
        searchBar.delegate = self
        resultsCollection.delegate = self
        resultsCollection.dataSource = self
        resultsCollection.register(UINib.init(nibName: K.collectionViewCell, bundle: nil), forCellWithReuseIdentifier: K.collectionViewCell)
        repositaryPresenter = RepositoryPresenter()
        repositaryPresenter.attachView(view: self)
        repositaryPresenter.setupUI()
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText != " " else {
            return
        }
        repositaryPresenter?.searchFor(repo: searchText)
        searchBar.resignFirstResponder()
    }
}

extension ViewController: AllRepositoriesView {
    func scrollToTop() {
        resultsCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    
    func showProgressHud() {
        ProgressHUD.show()
        view.isUserInteractionEnabled = false
    }
    
    func hideProgressHud() {
        ProgressHUD.dismiss()
        view.isUserInteractionEnabled = true
    }
    
    func open(detailedView: DetailedRepositoryView) {
        self.navigationController?.pushViewController(detailedView as! DetailViewController, animated: true)
    }
    
    func reload() {
        resultsCollection.reloadSections(IndexSet(arrayLiteral: 0))
    }
    
    func setLastSearch(text: String) {
        searchBar.text = text
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        repositaryPresenter.tapOnCell(with: indexPath)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == repositaryPresenter.repos.count - 1 {
            repositaryPresenter.loadMore()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repositaryPresenter?.repos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let repo = repositaryPresenter.repos[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.collectionViewCell, for: indexPath) as! RepositoryCellCollectionViewCell
        cell.configure(with: repo)
        
        return cell
    }
}


class CustomLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}



protocol AllRepositoriesView: class {
    var repositaryPresenter: RepositoryPresenterProtocol! { get set }
    func showProgressHud()
    func hideProgressHud()
    func open(detailedView: DetailedRepositoryView)
    func reload()
    func setLastSearch(text: String)
    func scrollToTop()
    
}
