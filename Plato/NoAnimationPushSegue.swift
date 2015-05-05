import UIKit

class NoAnimationPushSegue: UIStoryboardSegue {
    
    override func perform() {
        let source = sourceViewController as! UIViewController
        if let navigation = source.navigationController {
            navigation.pushViewController(destinationViewController as! UIViewController, animated: false)
        }
    }
    
}