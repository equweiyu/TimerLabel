//
//  TimerLabel.swift
//  TimerLabel
//
//  Created by 白天伟 on 2019/4/18.
//  Copyright © 2019 白天伟. All rights reserved.
//

import UIKit

@IBDesignable public class TimerLabel: UILabel {
    
    @IBInspectable public var autoHidden: Bool = false
    @IBInspectable public var autoStart: Bool = false
    @IBInspectable public var count: Int = 0
    @IBInspectable public var endText: String?
    private var textNum: Int = 0
    
    public var timer: DispatchSourceTimer? = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
    
    public func schedule() {
        timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1))
    }
    
    public func setEventHandler(handler: ((TimerLabel)-> Void)? ) {
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
    
    override public func awakeFromNib() {
        setup()
    }
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
