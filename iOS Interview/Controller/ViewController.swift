//
//  ViewController.swift
//  iOS Interview
//
//  Copyright © 2019 Talkspace. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    
    var therapists:[Therapist] = []
    var therapistViewModels:[TherapistViewModel] = []
    var gapViewModels:[GapViewModel] = []
    var gapsButtonPressed = false

    override func viewDidLoad() {

        self.title = "Therapist Roster"
        tableView.register(UINib(nibName: "TherapistTableViewCell", bundle: nil), forCellReuseIdentifier: "therapistCell")
        tableView.register(UINib(nibName: "GapTableViewCell", bundle: nil), forCellReuseIdentifier: "gapCell")

        tableView.rowHeight = UITableView.automaticDimension
        fetchData()
        // Do any additional setup after loading the view.
    }
    //how to set up gaps
    fileprivate func fetchData() {
        Service.shared.fetchTherapists { (therapists, err) in
            if let err = err {
                print("Failed to fetch therapists:", err)
                return
            }
            else{
                self.therapists = therapists
                for therapist in self.therapists{
                    let therapistViewModel = TherapistViewModel(therapist: therapist)
                    self.therapistViewModels.append(therapistViewModel)
                }
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    //Button Actions
    
    @IBAction func startingSoonButtonPressed(_ sender: Any) {
        therapistViewModels.removeAll()
        gapsButtonPressed = false

        for therapist in self.therapists{
            let therapistViewModel = TherapistViewModel(therapist: therapist)
            if therapistViewModel.timeUntilStarts > 0 {
                self.therapistViewModels.append(therapistViewModel)
            }
            
        }
        
        self.therapistViewModels = self.therapistViewModels.sorted(by: { $0.timeUntilStarts < $1.timeUntilStarts })
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    @IBAction func onDutyButtonPressed(_ sender: Any) {
        therapistViewModels.removeAll()
        gapsButtonPressed = false

          for therapist in self.therapists{
              let therapistViewModel = TherapistViewModel(therapist: therapist)
              if therapistViewModel.timeUntilEnds > 0 {
                  self.therapistViewModels.append(therapistViewModel)
              }
          }
          self.therapistViewModels = self.therapistViewModels.sorted(by: { $0.timeUntilEnds > $1.timeUntilStarts })
          DispatchQueue.main.async{
              self.tableView.reloadData()
          }
    }
    @IBAction func gapsButtonPressed(_ sender: Any) {
        gapsButtonPressed = true
        therapistViewModels.removeAll()
        gapViewModels.removeAll()
        self.therapists = self.therapists.sorted(by: { $0.shiftInfo.start  < $1.shiftInfo.start })
        
        var tupleArray: [(Int,Int)] = []
        
        for therapist in self.therapists{
            let total = therapist.shiftInfo.start + therapist.shiftInfo.duration
            let tempTuple = (therapist.shiftInfo.start, total)
            tupleArray.append(tempTuple)
        }

        let arrayOfGapTuples = tupleParsing(tupleArray: tupleArray)
        for tuple in arrayOfGapTuples{
            let gapViewModel = GapViewModel(startOfGap: tuple.0, endOfGap: tuple.1)
            self.gapViewModels.append(gapViewModel)
        }
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        
        
    }
}

extension ViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if gapsButtonPressed == false{
            return therapistViewModels.count
        } else{
            return gapViewModels.count
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gapsButtonPressed == false{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "therapistCell") as? TherapistTableViewCell
            else { return UITableViewCell()}
        cell.therapistViewModel = self.therapistViewModels[indexPath.row]
        return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "gapCell") as? GapTableViewCell
                else { return UITableViewCell()}
            cell.gapViewModel = self.gapViewModels[indexPath.row]
            return cell

        }
    }
}
extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
    
}

//tuple parsing
extension ViewController {
    func tupleParsing(tupleArray: [(Int, Int)]) -> [(Int,Int)]{
        var arrayOfTuples: [(Int,Int)] = tupleArray
        var arrayOfGapTuples: [(Int,Int)] = []
        let secondsInADay = 86400
        arrayOfTuples.append((secondsInADay-1, secondsInADay))
        for index in 0...arrayOfTuples.count-1 {
            if index+1 < arrayOfTuples.count{
                if arrayOfTuples[index].1 > arrayOfTuples[index+1].0 && arrayOfTuples[index].1 > arrayOfTuples[index+1].1 {
                    arrayOfTuples.remove(at: index+1)
                }
            }
        }
        
        for index in 0...arrayOfTuples.count-1 {
            if index+1 < arrayOfTuples.count{
                let tempTuple = (arrayOfTuples[index].1, arrayOfTuples[index+1].0)
                arrayOfGapTuples.append(tempTuple)
                
            }
        }
        for index in stride(from: arrayOfGapTuples.count-1, through: 0, by: -1) {
            if index < arrayOfGapTuples.count{
                if arrayOfGapTuples[index].1 < arrayOfGapTuples[index].0  {
                    arrayOfGapTuples.remove(at: index)
                }
            }
        }
        return arrayOfGapTuples
        
    }
    
}
