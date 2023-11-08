//
//  ValidateViewController.swift
//  SeSACRxSummery
//
//  Created by 백래훈 on 11/7/23.
//

import UIKit
import RxSwift
import RxCocoa

class ValidateViewController: UIViewController {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var validationLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    
    let viewModel = ValidateViewModel()
    
    let disposeBag = DisposeBag()
    
    let buttonStatus = BehaviorSubject(value: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    func bind() {
        
        let input = ValidateViewModel.Input(text: nameTextField.rx.text, tap: nextButton.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.text
            .bind(to: validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(to: nextButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validation
            .bind(with: self) { owner, value in
                let color: UIColor = value ? .systemPink : .systemGray5
                owner.nextButton.backgroundColor = color
            }
            .disposed(by: disposeBag)

        output.tap
            .bind(with: self) { owner, _ in
                print("show alert")
            }
            .disposed(by: disposeBag)
        
        
    }
    
}
