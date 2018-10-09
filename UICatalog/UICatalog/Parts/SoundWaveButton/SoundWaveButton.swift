//
//  SoundWaveButton.swift
//  UICatalog
//
//  Created by 横山 拓也 on 2018/09/25.
//  Copyright © 2018年 Takuya Yokoyama. All rights reserved.
//

import UIKit

open class SoundWaveButton: UIView, XibInitializable {
    public typealias Volume = Double
    
    open var delegate: SoundWaveButtonDelegate?
    
    @IBOutlet weak var button: UIButton!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setXibView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setXibView()
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        round()
        button.round()
    }
    
    public func wave(volume: Volume) {
        
    }
    
    @IBAction func didTappedButton(_ sender: UIButton) {
        delegate?.soundWaveButton(self, didTappedButton: sender)
    }
    
}

public protocol SoundWaveButtonDelegate: class {
    func soundWaveButton(_ soundWaveButton: SoundWaveButton, didTappedButton button: UIButton)
}
