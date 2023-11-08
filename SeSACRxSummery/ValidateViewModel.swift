//
//  ValidateViewModel.swift
//  SeSACRxSummery
//
//  Created by 백래훈 on 11/7/23.
//

import Foundation
import RxSwift
import RxCocoa

class ValidateViewModel {
    
    struct Input {
        let text: ControlProperty<String?> // nameTextField.rx.text
        let tap: ControlEvent<Void> // nextButton.rx.tap
    }
    
    struct Output {
        let tap: ControlEvent<Void>
        let text: Observable<String> // Driver<String>
        let validation: Observable<Bool>
    }
    
    init() {
        
    }
    
    func transform(input: Input) -> Output {
        
        let validation = input.text
            .orEmpty
            .map { $0.count >= 8 }
        
        let validText = Observable.of("닉네임은 8글자 이상")
        
        return Output(
            tap: input.tap,
            text: validText,
            validation: validation)
    }
    
}
