import UIKit
import SnapKit

class TodoCell:UITableViewCell {
  static var identifire = "TodoCell"
    
    private var titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 16)
        lbl.text = "laboriosam mollitia et enim quasi adipisci quia provident illum"
        lbl.numberOfLines = 0
        lbl.textColor = .black
        return lbl
    }()
    private var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Qudrat"
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .gray
        return lbl
    }()
     var backV: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
         view.clipsToBounds = true
         view.layer.cornerRadius = 12
         view.layer.borderColor = UIColor.systemGray5.cgColor
         view.layer.borderWidth = 1
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setConstraints(){
       contentView.addSubview(backV)
        backV.addSubview(nameLbl)
        backV.addSubview(titleLbl)
        
       backV.snp.makeConstraints { make in
           make.left.right.equalToSuperview().inset(8)
           make.top.bottom.equalToSuperview().inset(4)
       }
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(16)
        }
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp_bottomMargin).offset(12)
            make.left.right.equalToSuperview().inset(24)
            
        }
    }
    
    func apperenceSettings(_ task: TodoTask) {
        nameLbl.text = task.user.name
        titleLbl.text = task.todo.title
        
    }
    
}
