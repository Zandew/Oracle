import Cocoa
import SwiftUI
import Alamofire

class SearchVC: NSViewController {
    
    @IBOutlet weak var searchField: NSTextField!
    @IBOutlet weak var searchButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showResults), name: Notification.Name("showResults"), object: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchField.stringValue != "" {
            let search = searchField.stringValue.replacingOccurrences(of: " ", with: "%20")
            AlamoRequest.get(url: "https://api.spotify.com/v1/search?q=\(search)&type=track")
            //let hostingController = NSHostingController(rootView: SearchResultsView(results: AlamoRequest.songList!))
        }
    }
    
    @objc func showResults() {
        let hostingController = NSHostingController(rootView: SearchResultsView(results: AlamoRequest.songList))
        ShowPopover.showPopover(popView: hostingController, mainView: searchButton, behaviour: .transient, side: .maxY)
    }
    
}

