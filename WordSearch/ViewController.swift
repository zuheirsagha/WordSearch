import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet var collectionView : UICollectionView!
    var screenSize : CGRect!
    var screenWidth : CGFloat!
    var screenHeight : CGFloat!
    var words = ["Words:", "Swift", "Kotlin", "ObjectiveC", "Variable", "Java", "Mobile"]
    var wordIndexes : [[Int]] = [[32,36], [0,5], [10,19], [29,99], [75,78], [41,91]]

    var lastTappedIndex : Int?
    var found = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenSize = self.view.frame
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 107
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row >= 100 {
            return CGSize(width: screenWidth, height: 40);
        }
        return CGSize(width: screenWidth/10, height: screenWidth/10);
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        cell.backgroundColor = .white
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.5
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height))
        
        if indexPath.row >= 100 {
            label.text = words[indexPath.row - 100]
        }
        else if indexPath.row >= 32 && indexPath.row < 37 {
            label.text = "\(Array(words[1])[indexPath.row%10-2].uppercased())"
            label.textAlignment = .center
        }
        else if indexPath.row >= 0 && indexPath.row < 6 {
            label.text = "\(Array(words[2])[indexPath.row%10].uppercased())"
            label.textAlignment = .center
        }
        else if indexPath.row >= 10 && indexPath.row < 20 {
            label.text = "\(Array(words[3])[indexPath.row%10].uppercased())"
            label.textAlignment = .center
        }
        else if indexPath.row%10 == 9 && indexPath.row > 20 && indexPath.row < 100 {
            label.text = "\(Array(words[4])[indexPath.row/10-2].uppercased())"
            label.textAlignment = .center
        }
        else if indexPath.row >= 75 && indexPath.row < 79 {
            label.text = "\(Array(words[5])[indexPath.row%10-5].uppercased())"
            label.textAlignment = .center
        }
        else if indexPath.row%10 == 1 && indexPath.row > 40 && indexPath.row < 100 {
            label.text = "\(Array(words[6])[indexPath.row/10-4].uppercased())"
            label.textAlignment = .center
        }
        else {
            label.text = (65...90).map {String(UnicodeScalar($0))}.randomElement()
            label.textAlignment = .center
        }
        
        cell.addSubview(label)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if indexPath.row < 100 {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.backgroundColor = UIColor.lightGray
            
            for (i, ind) in wordIndexes.enumerated() {
                guard let last = lastTappedIndex else {
                    lastTappedIndex = indexPath.row
                    return
                }
                if ind.contains(last) && ind.contains(indexPath.row) && indexPath.row != last {
                    found = found + 1
                    let wordLength = words[i+1].count
                    var start = 0
                    if last < indexPath.row {
                        start = last
                    }
                    else {
                        start = indexPath.row
                    }
                    for i in 0..<wordLength {
                        if start != 29 && start != 41 {
                            let cell = collectionView.cellForItem(at: IndexPath.init(row: start + i, section: 0))
                            cell?.backgroundColor = UIColor.green
                        }
                        else {
                            let cell = collectionView.cellForItem(at: IndexPath.init(row: start + i*10, section: 0))
                            cell?.backgroundColor = UIColor.green
                        }
                    }
                    
                    let cell = collectionView.cellForItem(at: IndexPath.init(row: 101+i, section: 0))
                    cell?.backgroundColor = UIColor.green
                    break
                }
                else {
                    let cell = collectionView.cellForItem(at: IndexPath.init(row: last, section: 0))
                    cell?.backgroundColor = UIColor.white
                }
            }
            lastTappedIndex = indexPath.row
        }
        
        if found == 6 {
            let alertController = UIAlertController(title: "Congratulations", message: "You have found all of the words", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) {
                UIAlertAction in
                
                for cell in collectionView.visibleCells {
                    cell.backgroundColor = .white
                    self.found = 0
                }
            }
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
