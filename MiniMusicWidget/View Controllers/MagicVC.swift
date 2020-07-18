import Cocoa

class MagicVC: NSViewController {
    
    @IBOutlet weak var text: NSTextField!
    @IBOutlet weak var containerView: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func textSubmit(_ sender: Any) {
        //AlamoRequest.getMoods(text: text.stringValue)
        self.performSegue(withIdentifier: "toRecommendedSongs", sender: self)
    }
    
}
