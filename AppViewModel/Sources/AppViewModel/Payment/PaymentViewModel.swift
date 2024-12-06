//
//  PaymentViewModel.swift
//  
//
//  Created by Er Baghdasaryan on 27.11.24.
//
import Foundation
import AppModel
import ApphudSDK

public protocol IPaymentViewModel {

}

public class PaymentViewModel: IPaymentViewModel {

    private let paymentService: IPaymentService

    public init(paymentService: IPaymentService) {
        self.paymentService = paymentService
    }
}
