import Cocoa
import SwiftUI
import Alamofire
import WebKit
import OAuthSwift

class MainVC: NSViewController {
    
    var searchPopover: NSPopover?
    var playlistPopover: NSPopover?
    var TAWindow: NSWindow?

    @IBOutlet weak var previousButton: NSButton!
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var nextButton: NSButton!
    @IBOutlet weak var musicSlider: NSSliderCell!
    @IBOutlet weak var addSongButton: NSButton!
    @IBOutlet weak var playlistButton: NSButton!
    @IBOutlet weak var songName: NSTextField!
    @IBOutlet weak var magicButton: NSButton!
    @IBOutlet weak var imageCell: NSImageView!
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(initTimer), name: Notification.Name("initTimer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(invalidateTimer), name: Notification.Name("invalidateTimer"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("initTimer"), object: nil)
        
        let searchHC = NSHostingController(rootView: SearchView())
        searchPopover = Popover.createPopover(popView: searchHC)
        NSApp.activate(ignoringOtherApps: true)
        let vc = NSHostingController(rootView: ToneAnalyzerView())
        TAWindow = NSWindow(contentViewController: vc)
        TAWindow?.title = "Song Recommendations"
        TAWindow?.styleMask.remove(.resizable)
        TAWindow?.setFrame(NSMakeRect(100, 100, 500, 300), display: true)
        TAWindow?.center()
    }
    
    @IBAction func previousPressed(_ sender: Any) {
        NSAppleScript.go(code: NSAppleScript.setTime(time: 0), completionHandler: {_, _, _ in})
    }
    
    @IBAction func playPausePressed(_ sender: Any) {
        if UserData.playlist.count > 0 {
            NSAppleScript.go(code: NSAppleScript.togglePlay(), completionHandler: {_, _, _ in})
        }
    }
    
    @IBAction func nextPressed(_ sender: Any) {
        UserData.songIndex = (UserData.songIndex+1)%UserData.playlist.count
        NSAppleScript.go(code: NSAppleScript.playSong(uri: UserData.playlist[UserData.songIndex].uri), completionHandler: {_, _, _ in})
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        if UserData.playlist.count == 0 {
            return
        }
        NotificationCenter.default.post(name: Notification.Name("invalidateTimer"), object: nil)
        let time = musicSlider.doubleValue
        NSAppleScript.go(code: NSAppleScript.setTime(time: time), completionHandler: {_, _, _ in})
        NotificationCenter.default.post(name: Notification.Name("initTimer"), object: nil)
        let timeLeft = UserData.playlist[UserData.songIndex].length*(1-time)
        NextSongTimer.instance.initTimer(timeLeft)
    }
    
    @IBAction func playlistPressed(_ sender: Any) {
        let playlistHC = NSHostingController(rootView: PlaylistView(playlist: UserData.playlist))
        playlistPopover = Popover.createPopover(popView: playlistHC)
        Popover.showPopover(popoverView: playlistPopover!, mainView: playlistButton, side: .maxY)
    }
    
    @IBAction func magicPressed(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        TAWindow!.makeKeyAndOrderFront(self)
    }
    
    @IBAction func addSongPressed(_ sender: Any) {
        Popover.showPopover(popoverView: searchPopover!, mainView: addSongButton, side: .maxY)
    }
    
    @objc func initTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func invalidateTimer() {
        timer?.invalidate()
    }
    
    @objc func update() {
        if UserData.playlist.count > 0 {
            songName.stringValue = UserData.playlist[UserData.songIndex].name
            NSAppleScript.go(code: NSAppleScript.getTime(), completionHandler: {_, output, _ in
                let out = Double(output?.stringValue ?? "0")!
                let tot = UserData.playlist[UserData.songIndex].length
                musicSlider.doubleValue = out/tot
            })
            imageCell.image = UserData.playlist[UserData.songIndex].image!
        }else {
            songName.stringValue = "No Song Currently Playing"
            imageCell.image = nil
        }
    }

}
