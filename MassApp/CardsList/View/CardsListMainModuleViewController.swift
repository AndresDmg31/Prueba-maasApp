//
//  CardsListMainModuleViewController.swift
//  MassApp
//
//  Created by Andres Dario Martinez Gonzalez on 4/11/25.
//

import UIKit

class CardsListMainModuleViewController: UIViewController, CardsListMainModuleViewProtocol {

    var viewPresenter: CardsListMainModulePresenterProtocol?
    var nav: UINavigationController?

    static let appGreenColor = UIColor(red: 87/255, green: 209/255, blue: 47/255, alpha: 1.0)

    private var tableView: UITableView!
    private var emptyStateView: UIView!
    private var emptyStateImageView: UIImageView!
    private var emptyStateLabel: UILabel!
    private var emptyStateSubtitleLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    private var floatingActionButton: UIButton!
    private var headerView: UIView!
    private var cardIconImageView: UIImageView!
    private var titleLabel: UILabel!
    private var cards: [TuLlaveCard] = []

    // MARK: - View - Initialization

    required init(presenter: CardsListMainModulePresenterProtocol) {
        self.viewPresenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        nav = self.navigationController
        view.backgroundColor = .white
        customizeUI()
        customizeNavigation()
        addViews()
        addConstrains()
        viewPresenter?.loadInitialData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewPresenter?.loadInitialData()
    }

    // MARK: - View - Setup

    func customizeUI() {
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0)

        setupHeaderView()

        tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardCell.self, forCellReuseIdentifier: "CardCell")
        tableView.rowHeight = 180
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false

        setupEmptyState()

        setupFloatingActionButton()

        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = CardsListMainModuleViewController.appGreenColor
    }

    private func setupHeaderView() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false

        headerView.backgroundColor = CardsListMainModuleViewController.appGreenColor

        cardIconImageView = UIImageView()
        cardIconImageView.translatesAutoresizingMaskIntoConstraints = false
        cardIconImageView.contentMode = .scaleAspectFit
        cardIconImageView.image = UIImage(systemName: "creditcard.fill")
        cardIconImageView.tintColor = .white

        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Mis Tarjetas"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white

        headerView.addSubview(cardIconImageView)
        headerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            cardIconImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            cardIconImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 58),
            cardIconImageView.widthAnchor.constraint(equalToConstant: 30),
            cardIconImageView.heightAnchor.constraint(equalToConstant: 24),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 55),

            headerView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setupEmptyState() {
        emptyStateView = UIView()
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        emptyStateImageView = UIImageView()
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.image = UIImage(systemName: "creditcard")
        emptyStateImageView.tintColor = .lightGray
        emptyStateImageView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)

        emptyStateLabel = UILabel()
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Aún no tienes tarjetas"
        emptyStateLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        emptyStateLabel.textColor = .darkGray
        emptyStateLabel.textAlignment = .center

        emptyStateSubtitleLabel = UILabel()
        emptyStateSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateSubtitleLabel.text = "Toca el botón para agregar una nueva tarjeta"
        emptyStateSubtitleLabel.font = .systemFont(ofSize: 16)
        emptyStateSubtitleLabel.textColor = .gray
        emptyStateSubtitleLabel.textAlignment = .center
        emptyStateSubtitleLabel.numberOfLines = 0

        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubtitleLabel)

        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateImageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),

            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 20),

            emptyStateSubtitleLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateSubtitleLabel.topAnchor.constraint(equalTo: emptyStateLabel.bottomAnchor, constant: 8),
            emptyStateSubtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor, constant: 40),
            emptyStateSubtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor, constant: -40)
        ])
    }

    private func setupFloatingActionButton() {
        floatingActionButton = UIButton(type: .system)
        floatingActionButton.translatesAutoresizingMaskIntoConstraints = false
        floatingActionButton.backgroundColor = CardsListMainModuleViewController.appGreenColor
        floatingActionButton.tintColor = .white
        floatingActionButton.setImage(UIImage(systemName: "plus"), for: .normal)
        floatingActionButton.setImage(UIImage(systemName: "plus"), for: .highlighted)
        floatingActionButton.layer.cornerRadius = 28
        floatingActionButton.layer.shadowColor = UIColor.black.cgColor
        floatingActionButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        floatingActionButton.layer.shadowRadius = 4
        floatingActionButton.layer.shadowOpacity = 0.2

        floatingActionButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    func customizeNavigation() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func addViews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(activityIndicator)
        view.addSubview(floatingActionButton)
    }

    func addConstrains() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 40),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -40),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            floatingActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            floatingActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            floatingActionButton.widthAnchor.constraint(equalToConstant: 56),
            floatingActionButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    // MARK: - Actions

    @objc private func addButtonTapped() {
        showAddCardAlert()
    }

     func showAddCardAlert() {
        let alert = UIAlertController(title: "Agregar Tarjeta", message: "Ingresa el serial de tu tarjeta TuLlave", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Serial de la tarjeta (16 dígitos)"
            textField.keyboardType = .numberPad
            textField.textContentType = .oneTimeCode
            textField.delegate = self
        }

        let addAction = UIAlertAction(title: "Agregar", style: .default) { [weak self, weak alert] _ in
            guard let serial = alert?.textFields?.first?.text else { return }
            self?.viewPresenter?.validateAndSaveCard(serial: serial)
        }

        addAction.setValue(CardsListMainModuleViewController.appGreenColor, forKey: "titleTextColor")

        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    // MARK: - CardsListMainModuleViewProtocol

    func showCards(_ cards: [TuLlaveCard]) {
        self.cards = cards
        emptyStateView.isHidden = !cards.isEmpty
        tableView.reloadData()
    }

    func showLoading(_ show: Bool) {
        if show {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }

    func showError(_ message: String) {
        showAlert(title: "Error", message: message)
    }

    func showSuccess(_ message: String) {
        showAlert(title: "Éxito", message: message)
    }

    func showCardDetail(_ card: TuLlaveCard) {
        let detailMessage = """
        Serial: \(card.serial)
        Nombre: \(card.fullName)
        Perfil: \(card.profile)
        Saldo: \(card.formattedBalance)
        """

        showAlert(title: "Detalle de Tarjeta", message: detailMessage)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension CardsListMainModuleViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 16
    }
}

// MARK: - UITableViewDataSource

extension CardsListMainModuleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let card = cards[indexPath.row]
        cell.configure(with: card)
        return cell
    }
}

// MARK: - Custom Card Cell

class CardCell: UITableViewCell {

    private let cardContainerView = UIView()
    private let cardNumberLabel = UILabel()
    private let cardholderNameLabel = UILabel()
    private let balanceLabel = UILabel()
    private let profileLabel = UILabel()
    private let chipImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell() {
        selectionStyle = .none
        backgroundColor = .clear

        setupCardContainer()
        setupCardElements()
        addConstraints()
    }

    private func setupCardContainer() {
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardContainerView.backgroundColor = .white
        cardContainerView.layer.cornerRadius = 16
        cardContainerView.layer.masksToBounds = true
        cardContainerView.layer.borderWidth = 1
        cardContainerView.layer.borderColor = UIColor(red: 0.0, green: 0.5, blue: 0.2, alpha: 1.0).cgColor

        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowOpacity = 0
    }

    private func setupCardElements() {
        chipImageView.translatesAutoresizingMaskIntoConstraints = false
        chipImageView.image = UIImage(named: "cardGreen")
        chipImageView.contentMode = .scaleAspectFit
        chipImageView.layer.cornerRadius = 8
        chipImageView.layer.masksToBounds = true
        
        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNumberLabel.font = .systemFont(ofSize: 20, weight: .medium)
        cardNumberLabel.textColor = .black
        
        cardholderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardholderNameLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cardholderNameLabel.textColor = .darkGray
        
        profileLabel.translatesAutoresizingMaskIntoConstraints = false
        profileLabel.font = .systemFont(ofSize: 14)
        profileLabel.textColor = .gray
        
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        balanceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        balanceLabel.textColor = CardsListMainModuleViewController.appGreenColor

        cardContainerView.addSubview(chipImageView)
        cardContainerView.addSubview(cardNumberLabel)
        cardContainerView.addSubview(cardholderNameLabel)
        cardContainerView.addSubview(profileLabel)
        cardContainerView.addSubview(balanceLabel)
        contentView.addSubview(cardContainerView)
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardContainerView.heightAnchor.constraint(equalToConstant: 160),

            chipImageView.centerYAnchor.constraint(equalTo: cardContainerView.centerYAnchor),
            chipImageView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor, constant: -16),
            chipImageView.widthAnchor.constraint(equalToConstant: 90),
            chipImageView.heightAnchor.constraint(equalToConstant: 110),

            cardNumberLabel.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: 20),
            cardNumberLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            cardNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: chipImageView.leadingAnchor, constant: -20),

            cardholderNameLabel.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 12),
            cardholderNameLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            cardholderNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: chipImageView.leadingAnchor, constant: -20),

            profileLabel.topAnchor.constraint(equalTo: cardholderNameLabel.bottomAnchor, constant: 8),
            profileLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            profileLabel.trailingAnchor.constraint(lessThanOrEqualTo: chipImageView.leadingAnchor, constant: -20),

            balanceLabel.bottomAnchor.constraint(equalTo: cardContainerView.bottomAnchor, constant: -20),
            balanceLabel.topAnchor.constraint(greaterThanOrEqualTo: profileLabel.bottomAnchor, constant: 16),
            balanceLabel.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: 16),
            balanceLabel.trailingAnchor.constraint(lessThanOrEqualTo: chipImageView.leadingAnchor, constant: -20)
        ])
    }

    func configure(with card: TuLlaveCard) {
        cardNumberLabel.text = card.maskedSerial
        cardholderNameLabel.text = card.fullName
        balanceLabel.text = card.formattedBalance
        profileLabel.text = card.profile

        cardContainerView.backgroundColor = .white
        cardContainerView.layer.borderColor = CardsListMainModuleViewController.appGreenColor.cgColor
        cardContainerView.layer.borderWidth = 1
    }
}

// MARK: - UITableViewDelegate

extension CardsListMainModuleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewPresenter?.selectCard(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewPresenter?.deleteCard(at: indexPath.row)
        }
    }
}

