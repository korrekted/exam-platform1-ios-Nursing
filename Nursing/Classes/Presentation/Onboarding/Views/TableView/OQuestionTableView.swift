//
//  OQuestionTableView.swift
//  Nursing
//
//  Created by Виталий Загороднов on 15.02.2022.
//

import UIKit

final class OQuestionTableView: UITableView {
    private lazy var elements = [OTestCellType]()
    
    private var selectedCell: IndexPath? {
        didSet {
            if let indexPath = selectedCell {
                if case let .answer(answer) = elements[safe: indexPath.row] {
                    didSelectAnswer?(answer)
                }
            }
        }
    }
    
    var didSelectAnswer: ((OAnswerElement) -> Void)?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: API
extension OQuestionTableView {
    func setup(question: OQuestionElement, didSelectAnswer: ((OAnswerElement) -> Void)? = nil) {
        elements = question.elements
        allowsMultipleSelection = false
        self.didSelectAnswer = didSelectAnswer
        reloadData()
    }
}

// MARK: UITableViewDataSource
extension OQuestionTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = elements[indexPath.row]
        switch element {
        case let .question(question, html):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OQuestionCell.self), for: indexPath) as! OQuestionCell
            cell.configure(question: question, questionHtml: html)
            return cell
        case let .answer(answer):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OAnswerCell.self), for: indexPath) as! OAnswerCell
            cell.setup(element: answer)
            return cell
        case let .explanation(explanation):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OExplanationCell.self), for: indexPath) as! OExplanationCell
            cell.setup(explanation: explanation)
            return cell
        case let .comment(isError, comment):
            let cell = dequeueReusableCell(withIdentifier: String(describing: OCommentCell.self), for: indexPath) as! OCommentCell
            cell.setup(isError: isError, comment: comment)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension OQuestionTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        tableView.cellForRow(at: indexPath) is OAnswerCell ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let selectedIndex = selectedCell, selectedIndex == indexPath {
            selectedCell = nil
        } else {
            selectedCell = indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch elements[indexPath.row] {
        case let .answer(element):
            return OAnswerCell.height(for: element, with: tableView.bounds.width)
        case .explanation, .question, .comment:
            return UITableView.automaticDimension
        }
    }
}

// MARK: Private
private extension OQuestionTableView {
    func initialize() {
        register(OAnswerCell.self, forCellReuseIdentifier: String(describing: OAnswerCell.self))
        register(OQuestionCell.self, forCellReuseIdentifier: String(describing: OQuestionCell.self))
        register(OCommentCell.self, forCellReuseIdentifier: String(describing: OCommentCell.self))
        register(OExplanationCell.self, forCellReuseIdentifier: String(describing: OExplanationCell.self))
        separatorStyle = .none
        
        dataSource = self
        delegate = self
    }
}

