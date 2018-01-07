import UIKit

class EmptyViewController: UIViewController {
    
    //back button weergeven bij ipad als het op empty datailscherm verschijnt
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = splitViewController!.displayModeButtonItem
    }
}

