//
//  ViewModelType.swift
//  SeSACRxSummery
//
//  Created by 백래훈 on 11/8/23.
//

import Foundation

protocol ViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}

//class TestViewModel: ViewModelType {
//    
//    typealias Input = Jack
//    
//    typealias Output = Hue
//    
//    struct Jack {
//        
//    }
//    
//    struct Hue {
//        
//    }
//    
//    func transform(input: Jack) -> Hue {
//        <#code#>
//    }
//    
//}
