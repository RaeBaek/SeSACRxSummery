//
//  ViewController.swift
//  SeSACRxSummery
//
//  Created by jack on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let searchBar = UISearchBar()
    
    let viewModel = BoxOfficeViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func bind() {
        
        let recentText = PublishSubject<String>()
        
        let input = BoxOfficeViewModel.Input(
            searchButtonTap: searchBar.rx.searchButtonClicked,
            searchText: searchBar.rx.text.orEmpty,
            recentText: recentText
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.movieNm) \(element.openDt)"
            }
            .disposed(by: disposeBag)
        
        output.recent
            .asDriver() // Driver<[String]>
            .drive(collectionView.rx.items(cellIdentifier: "MovieCollectionCell", cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = "\(element) @ row \(row)"
            }
            .disposed(by: disposeBag)
        
        Observable.zip(tableView.rx.modelSelected(DailyBoxOfficeList.self), tableView.rx.itemSelected)
            .map { $0.0.movieNm }
            .subscribe(with: self) { owner, value in
                recentText.onNext(value)
                
            }
            .disposed(by: disposeBag)
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.backgroundColor = .green
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        collectionView.backgroundColor = .red
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
     
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
   
}
