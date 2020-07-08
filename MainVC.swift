import Cocoa
import SwiftUI
import Alamofire

class MainVC: NSViewController {
    
    var searchView: NSViewController?
    var playlist: [Song] = []

    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var addSongButton: NSButton!
    @IBOutlet weak var playlistButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchView = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SearchVC") as? NSViewController
        NotificationCenter.default.addObserver(self, selector: #selector(addSong(notification:)), name: Notification.Name("addSong"), object: nil)
    }
    
    @IBAction func previousPressed(_ sender: Any) {
    }
    
    @IBAction func playPausePressed(_ sender: Any) {
    }
    
    @IBAction func nextPressed(_ sender: Any) {
    }
    
    @IBAction func playlistPressed(_ sender: Any) {
        let hostingController = NSHostingController(rootView: PlaylistView(playlist: playlist))
        ShowPopover.showPopover(popView: hostingController, mainView: playlistButton, behaviour: .transient, side: .maxY)
    }
    
    @IBAction func addSongPressed(_ sender: Any) {
        ShowPopover.showPopover(popView: searchView!, mainView: addSongButton, behaviour: .transient, side: .maxY)
    }
    
    @objc func addSong(notification: Notification) {
        let song = notification.userInfo!["songURI"]!
        playlist.append((song as? Song)!)
        print("Song Added")
    }
}

