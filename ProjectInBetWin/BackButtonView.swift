//
//  BackButtonView.swift
//  ProjectInBetWin
//
//  Created by Arvin San Miguel on 12/29/16.
//  Copyright © 2016 Appr1sing Studios. All rights reserved.
//

import UIKit

class BackButtonView: UIView {
    
    override func draw(_ rect: CGRect) {
        BackButton.drawBackButton(frame: bounds, resizing: .aspectFill)
    }

}
