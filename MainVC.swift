import Cocoa
import SwiftUI
import Alamofire

class MainVC: NSViewController {
    
    var searchView: NSViewController?

    
    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var addSongButton: NSButton!
    @IBOutlet weak var playlistButton: NSButton!
    @IBOutlet weak var songName: NSTextField!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        searchView = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SearchVC") as? NSViewController

        NotificationCenter.default.addObserver(self, selector: #selector(initTimer), name: Notification.Name("initTimer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: Notification.Name("invalidateTimer"), object: nil)
        
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @IBAction func previousPressed(_ sender: Any) {
    }
    
    @IBAction func playPausePressed(_ sender: Any) {
    }
    
    @IBAction func nextPressed(_ sender: Any) {
    }
    
    @IBAction func playlistPressed(_ sender: Any) {
        let hostingController = NSHostingController(rootView: PlaylistView(playlist: UserData.playlist))
        ShowPopover.showPopover(popView: hostingController, mainView: playlistButton, behaviour: .transient, side: .maxY)
    }
    
    @IBAction func addSongPressed(_ sender: Any) {
        ShowPopover.showPopover(popView: searchView!, mainView: addSongButton, behaviour: .transient, side: .maxY)
    }
    
    @objc func initTimer() {
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func invalidateTimer() {
        timer?.invalidate()
    }
    
    @objc func update() {
        if UserData.playlist.count > 0 {
            songName.stringValue = UserData.playlist[UserData.songIndex].name
        }else {
            songName.stringValue = "No Song Currently Playing"
        }
    }
    
}

