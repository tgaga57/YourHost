//
//
//
//  Created by 志賀大河 on 2020/01/31.
//  Copyright © 2020 Taiga Shiga. All rights reserved.
//

import Foundation
import UIKit

class TextAction: UIViewController,UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
