//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import UIKit
import Combine
import CombineCocoa

final class SearchViewController: UIViewController {

    private let viewModel: SearchViewModel

    enum Section: Int {
        case main
    }

    @AutoLayoutable private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        searchBar.returnKeyType = .search
        searchBar.sizeToFit()
        return searchBar
    }()

    @AutoLayoutable private var collectionView = SearchCollectionView()

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchItemViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchItemViewModel>
    private lazy var dataSource = setupDataSource()

    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Init

    init(_ viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Send"
        setUpBindings()
        configureUI()
    }

    private func setUpBindings() {
        viewModel
            .$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                case .idle:
                    break
                case .failed(let error):
                    print(error.localizedDescription)
                case .loading:
                    print("loading")
                case .loaded(let viewModels):
                    self.updateSections(viewModels)
                }
            }
            .store(in: &subscriptions)

        viewModel
            .viewOutputEventPublisher
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .dismiss:
                    self.dismiss(animated: true)
                }
            }
            .store(in: &subscriptions)

        searchBar
            .textDidChangePublisher
            .sink { [weak self] text in
                guard let self = self else { return }
                self.viewModel.viewInputEvent.send(.textDidChange(text))
                self.searchBar.setShowsCancelButton(true, animated: true)
            }
            .store(in: &subscriptions)

        searchBar
            .searchButtonClickedPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.clearSearchBarState()
            }
            .store(in: &subscriptions)

        searchBar
            .cancelButtonClickedPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.viewInputEvent.send(.cancelButtonClicked)
                self.clearSearchBarState()
            }
            .store(in: &subscriptions)
    }

    private func configureUI() {
        configureSearchBar()
        configureCollectionView()
    }

    private func configureSearchBar() {
        view.addSubview(searchBar)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item -> UICollectionViewCell? in
            guard let self = self else { return nil }

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reuseIdentifier, for: indexPath) as? SearchCollectionViewCell
            else { return nil }

            cell.setup(item)
            return cell
        }

        return dataSource
    }

    private func updateSections(_ viewModels: [SearchItemViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(viewModels, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func clearSearchBarState() {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.viewInputEvent.send(.didSelectItem(indexPath))
    }
}
