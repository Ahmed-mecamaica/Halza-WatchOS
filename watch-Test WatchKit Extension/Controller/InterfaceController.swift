//
//  InterfaceController.swift
//  watch-Test WatchKit Extension
//
//  Created by Ahmed Medhat on 26/10/2021.
//

import WatchKit
import Foundation
import UIKit
import SDWebImage

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var userNameLbl: WKInterfaceLabel!
    @IBOutlet weak var userTitleLbl: WKInterfaceLabel!
    @IBOutlet weak var holderView: WKInterfaceGroup!
    @IBOutlet weak var qrCodeImage: WKInterfaceImage!
    @IBOutlet weak var leftBtn: WKInterfaceButton!
    @IBOutlet weak var rightBtn: WKInterfaceButton!
    
    var userNameArray: [String] = [String]()
    var qrImageArray: [String] = [String]()
    var medicalCaseName: [String] = [String]()
    var counter = 0
    var dotNum = ""
    var dotNumArray: [String] = [String]()
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        initFetchDataFromServer()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func initFetchDataFromServer() {
        hideAllComponentOfScreen()
        APIService.shared.getQRMeScreenData { [weak self] response, error in
            guard let self = self else {
                return
            }
            
            if let response = response {
                self.userNameArray.append(response.name)
                self.medicalCaseName.append(response.medicalCaseName)
                self.qrImageArray.append(response.fileUri)
                
                DispatchQueue.main.async {
                    
                    self.userNameLbl.setText(self.userNameArray[self.counter])
                    
                    //substring of qrCode url
                    if let range = response.fileUri.range(of: ".png") {
                        let firstPart = response.fileUri[response.fileUri.startIndex..<range.upperBound]
                        self.qrCodeImage.sd_setImage(with: URL(string: String(firstPart))!)
                    }
                    
                    self.userTitleLbl.setText(self.medicalCaseName[self.counter])
                }
                self.animate(withDuration: 0.4) {
                    self.initBussinessLogicOfShowComponentView()
                }
            }
            
            else {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    func hideAllComponentOfScreen() {
        holderView.setAlpha(0)
        leftBtn.setAlpha(0)
        rightBtn.setAlpha(0)
    }
    
    func initBussinessLogicOfShowComponentView() {
         if counter == 0 {
            self.leftBtn.setAlpha(0)
            self.rightBtn.setAlpha(1)
             holderView.setAlpha(1)
        }
        
        else if counter == qrImageArray.count - 1 {
            rightBtn.setAlpha(0)
            leftBtn.setAlpha(1)
            holderView.setAlpha(1)
        }
        if qrImageArray.count == 1 {
            rightBtn.setAlpha(0)
            leftBtn.setAlpha(0)
            holderView.setAlpha(1)

        }
        else {
            rightBtn.setAlpha(1)
            leftBtn.setAlpha(1)
            holderView.setAlpha(1)

        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.initBussinessLogicOfShowComponentView()
        }
    }
    
    @IBAction func leftBtnTapped() {
        counter -= 1
        self.userNameLbl.setText(userNameArray[counter])
        self.qrCodeImage.setImageNamed(qrImageArray[counter])
        self.userTitleLbl.setText(medicalCaseName[counter])
    }
    @IBAction func rightBtnTapped() {
//        if qrImageArray != 1{
            leftBtn.setAlpha(1)
            counter += 1
            self.userNameLbl.setText(userNameArray[counter])
            self.qrCodeImage.setImageNamed(qrImageArray[counter])
            self.userTitleLbl.setText(medicalCaseName[counter])
//        }
        
    }
   

}
