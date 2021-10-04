//
//  FirstViewController.swift
//  ios-stations
//

import UIKit
//import Alamofire

class FirstViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backDataButton: UIButton!
    @IBOutlet weak var reloadDataButton: UIButton!
    @IBOutlet weak var nextDataButton: UIButton!
    
    @IBAction func restoringData(_ sender: UIButton) {
        if offsetNum <= 0 {
            return
        } else if offsetNum < 10 {
            offsetNum = 0
        } else {
            offsetNum -= 10
        }
        self.tableView.reloadData()
        bookAPI.fetchBooks(offset: offsetNum) { (books) in
            guard let bookGuard: [Book] = books else {
                print("bookAPI.fetchBooks(offset: Int) にある guard let bookGuard = books においてreturnされました")
                return
            }
            self.books = bookGuard
        }
    }
    @IBAction func touchUpInside(_ sender: UIButton) {
        self.tableView.reloadData()
        bookAPI.fetchBooks(offset: offsetNum) { (books) in
            guard let bookGuard: [Book] = books else {
                print("bookAPI.fetchBooks(offset: Int) にある guard let bookGuard = books においてreturnされました")
                return
            }
            self.books = bookGuard
        }
    }
    @IBAction func skipData(_ sender: UIButton) {
        offsetNum += 10
        self.tableView.reloadData()
        bookAPI.fetchBooks(offset: offsetNum) { (books) in
            guard let bookGuard: [Book] = books else {
                print("bookAPI.fetchBooks(offset: Int) にある guard let bookGuard = books においてreturnされました")
                return
            }
            self.books = bookGuard
        }
    }
    
    var books: [Book]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    private let bookAPI: BookAPIClient = BookAPIClient()
    private var offsetNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backDataButton.setTitle("戻る", for: .normal)
        reloadDataButton.setTitle("更新", for: .normal)
        nextDataButton.setTitle("次へ", for: .normal)
        
        backDataButton.layer.cornerRadius = 10.0
        reloadDataButton.layer.cornerRadius = 10.0
        nextDataButton.layer.cornerRadius = 10.0
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BookCell", bundle: nil), forCellReuseIdentifier: "reuseCell")
        scrollRefresh()
        
        bookAPI.fetchBooks(offset: offsetNum) { (books) in
            guard let bookGuard: [Book] = books else {
                print("bookAPI.fetchBooks(offset: Int) にある guard let bookGuard = books においてreturnされました")
                return
            }
            self.books = bookGuard
        }
        
        configureRefrenshControl()
    }
    
    func configureRefrenshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(scrollRefresh), for: .valueChanged)
    }
    
    @objc func scrollRefresh() {
        bookAPI.fetchBooks(offset: offsetNum) { (books) in
            guard let bookGuard: [Book] = books else {
                print("bookAPI.fetchBooks(offset: Int) にある guard let bookGuard = books においてreturnされました")
                return
            }
            self.books = bookGuard
        }
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension FirstViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookCell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! BookCell
        guard let bookGuard: [Book] = books else {
            print("func tableView(cellForRowAt) にある guard let bookGuard = books においてreturnされました")
            if let unwrappedBooks = books { print(unwrappedBooks) } else { print("nil") }
            return cell
        }
        cell.bookItem = bookGuard[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let bookGuard: [Book] = books else {
            print("func tableView(numberOfRowsInSection) にある guard let bookGuard = books においてreturnされました")
            return 0
        }
        return bookGuard.count
    }
}

//Tableviewから画面遷移
extension FirstViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bookGuard: [Book] = books else {
            print("func tableView(didSelectRowAt) にある guard let selectedTrail = booksにおいてreturnされました")
            return
        }
        
        let IndexRowUrl = bookGuard[indexPath.row].url
        let moveToSecondVC: SecondViewController = UIStoryboard(name: "SecondView", bundle: nil).instantiateViewController(identifier: "SecondViewController") as! SecondViewController
        
        if IndexRowUrl.prefix(7) == "http://" || IndexRowUrl.prefix(8) == "https://" {
            let clickAlert = UIAlertController(title: "外部リンクへ遷移します", message: nil, preferredStyle: .alert)
            
            clickAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _  in
                moveToSecondVC.receiveDataUrl = IndexRowUrl
                moveToSecondVC.modalPresentationStyle = .fullScreen
                self.present(moveToSecondVC, animated: true, completion: nil)
            }))
            clickAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(clickAlert, animated: true)
        } else {
            let clickAlert = UIAlertController(title: nil, message: "URL:\"\(bookGuard[indexPath.row].url)\"\nURLが適切ではありません", preferredStyle: .alert)
            
            clickAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
            
            present(clickAlert, animated: true)
            return
        }
    }
}


