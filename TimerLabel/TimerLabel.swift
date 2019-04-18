//
//  TimerLabel.swift
//  TimerLabel
//
//  Created by 白天伟 on 2019/4/18.
//  Copyright © 2019 白天伟. All rights reserved.
//

import UIKit

@IBDesignable class TimerLabel: UILabel {
    
    @IBInspectable var autoHidden: Bool = false
    @IBInspectable var autoStart: Bool = false
    @IBInspectable var count: Int = 0
    @IBInspectable var endText: String?
    private var textNum: Int = 0
    
    var timer: DispatchSourceTimer? = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
    
    func schedule() {
        timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1))
    }
    
    func setEventHandler(handler: ((TimerLabel)-> Void)? ) {
        timer?.setEventHandler(handler: { [weak self] in
            if let self = self {
                handler?(self)
            }
        })
    }
    
    private func setup() {
        if autoStart {
            if count > 0 {
                schedule()
                textNum = count
                setEventHandler { (label) in
                    if label.textNum >= 0 {
                        label.text = "\(label.textNum)"
                        label.textNum -= 1
                    } else {
                        label.timer?.cancel()
                        label.isHidden = label.autoHidden
                        label.text =  self.endText
                    }
                }
                timer?.resume()
            }
        }
    }
    
    override func awakeFromNib() {
        setup()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
