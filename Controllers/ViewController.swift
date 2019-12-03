//
//  ViewController.swift
//  iOS Interview
//
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    var therapists = [Therapist]()
    var noTherapists = [Therapist]()
    var activeTherapists = [Therapist]()
    var allTherapists = [Therapist]()
    let dateFormatter = DateFormatter()
    let formatter = DateComponentsFormatter()
    let startDate = Date()
    let cal = Calendar(identifier: .gregorian)
    let dateInt = Int(Date().timeIntervalSince1970)
    var isChecked = false
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gapButton: UIButton!
    @IBOutlet weak var onDutyButton: UIButton!
    @IBOutlet weak var startingSoonButton: UIButton!
    
    @IBAction func sortByGap(_ sender: UIButton) {
        
        self.therapists = self.noTherapists.filter { $0.name == "Sigmund Freud" }

        self.tableView.reloadData()
        
    }
    
    @IBAction func sortByOnDuty(_ sender: UIButton) {
        
        self.therapists = self.activeTherapists.filter { $0.name == "Carl Jung" }

        self.tableView.reloadData()
        
    }
    @IBAction func sortByStartingSoon(_ sender: UIButton) {
        self.therapists = self.allTherapists.sorted(by: {
            return $0.start < $1.start
        })
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        // Table view delegate
        tableView.delegate = self
        tableView.dataSource = self

        // Register TherapistTableVieCell
        tableView.register(TherapistTableViewCell.nib,
        forCellReuseIdentifier: "TherapistTableViewCell")
        
        // Register NoTherapistTableVieCell
        tableView.register(NoTherapistTableViewCell.nib,
        forCellReuseIdentifier: "NoTherapistTableViewCell")
        
        self.therapists = self.allTherapists
        tableView.reloadData()
        
        tableView.tableFooterView = UIView()
        
        parse()
               
    }
    
func parse() {
   let url = Bundle.main.url(forResource: "therapists09", withExtension: "json")
   if let url = url {
       let data = try? Data(contentsOf: url)
       do {
            guard let data = data else {return}

            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary

            let therapistArray = json?.value(forKey: "therapists") as! NSArray
            for arrayData in therapistArray {
                let therapistJson = arrayData as! [String:Any]
                let shift = therapistJson["shiftInfo"] as! [String:Any]
                guard let name = therapistJson["name"] else {return}
                guard let id = therapistJson["id"] else {return}
                guard let primaryLicense = therapistJson["primaryLicense"] else {return}
                guard let therapistSince = therapistJson["therapistSince"] else {return}
                guard let start = shift["start"] else {return}
                guard let duration = shift["duration"] else {return}
                
                let therapist = Therapist(id: id as! Int, therapistSince: therapistSince as! Int, primaryLicense: primaryLicense as! String, name: name as! String, start: start as! Int, duration: duration as! Int)
                
                therapists.append(therapist)
                noTherapists.append(therapist)
                activeTherapists.append(therapist)
                allTherapists.append(therapist)
           }

       }

       catch let error as NSError {
           print(error.localizedDescription)
       }
   }
    
}


}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return therapists.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellA = tableView.dequeueReusableCell(withIdentifier: "TherapistTableViewCell",
                                                 for: indexPath) as! TherapistTableViewCell
        
        let cellB = tableView.dequeueReusableCell(withIdentifier: "NoTherapistTableViewCell",
        for: indexPath) as! NoTherapistTableViewCell
        
        let therapist = therapists[indexPath.row]
        
        // Get last name
        let name = therapist.name
        let split = name.split(separator: " ")
        let last = String(split.suffix(1).joined(separator: [" "]))
        cellA.nameLabel?.text = last
        
        // Get primary license string and therapistSince date
        let time = therapist.therapistSince
        let date = NSDate(timeIntervalSince1970: Double(time))
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/YYYY"
        let strDate = dateFormatter.string(from: date as Date)
        cellA.pHdSinceLabel?.text = therapist.primaryLicense + " since " + strDate
        
        // Calculate shift times
        dateFormatter.dateFormat = "h:mm a"
        let newDate = cal.startOfDay(for: startDate)
        let startTime = newDate.addingTimeInterval(Double(therapist.start))
        let formattedStartTime = dateFormatter.string(from: startTime)
        let endTime = startTime.addingTimeInterval(Double(therapist.duration))
        let formattedEndTime = dateFormatter.string(from: endTime)
        cellA.onDutyLabel?.text = "On Duty: " + formattedStartTime + " to " + formattedEndTime + ". "
        
        // Calculate duration left in shift
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(Double(therapist.duration)))!
        if startTime < startDate && startDate < endTime {
            cellA.onDutyLabel?.text = (cellA.onDutyLabel?.text ?? "") + " \(formattedString) till end"
        }
        
        // Calculate time left til shift starts
        if startDate < startTime {
            let timeDifference = Calendar.current.dateComponents([.hour, .minute], from: startTime, to: startDate)
            cellA.onDutyLabel?.text = (cellA.onDutyLabel?.text ?? "") + "\(timeDifference.hour!)hr \(timeDifference.minute!)min till start"
        }

        return cellA
       

    }
}
