//
//  ViewManager.swift
//
//
//  Created by Wongkraiwich Chuenchomphu on 15/4/23.
//

import UIKit

class ViewManager: ObservableObject {
    enum StackPosition {
        case top, bottom, none
    }
    
    enum Orientation {
        case portrait
        case landscape
    }
    
    @Published var isShowingSpeechEditor = false
    @Published var audioSessionInitFailed = false
    
    @Published var stackPosition: StackPosition = .none
    @Published var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
        
        init() {
            if UIDevice.current.orientation.isLandscape {
                self.orientation = .landscape
            }
            else {
                self.orientation = .portrait
            }
            
            _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
                guard let device = note.object as? UIDevice else {
                    return
                }
                if device.orientation.isPortrait {
                    self.orientation = .portrait
                }
                else if device.orientation.isLandscape {
                    self.orientation = .landscape
                }
            }
        }
        
        deinit {
            if let observer = _observer {
                NotificationCenter.default.removeObserver(observer)
            }
        }
}
