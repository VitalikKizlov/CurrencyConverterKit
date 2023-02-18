//
//  File.swift
//  
//
//  Created by Vitalii Kizlov on 15.02.2023.
//

import Foundation
import Combine

public final class SearchViewModel {

    // MARK: - Dependencies

    @Injected(\.countriesStoreService) private var countriesStoreService: CountriesStoreProtocol

    // MARK: - Input

    @Published private(set) var searchText = ""
    let viewInputEvent = PassthroughSubject<ViewInputEvent, Never>()
    private lazy var viewInputEventPublisher = viewInputEvent.eraseToAnyPublisher()

    // MARK: - Output

    private let viewOutputEvent = PassthroughSubject<ViewOutputEvent, Never>()
    lazy var viewOutputEventPublisher = viewOutputEvent.eraseToAnyPublisher()

    // MARK: - Properties

    @Published private(set) var state: LoadingState = .idle
    private var context: Context
    private var subscriptions: Set<AnyCancellable> = []

    // MARK: - Lifecycle

    public init(_ context: Context) {
        self.context = context
        setupBindings()
        configureInitialState()
    }

    // MARK: - Private

    private func configureInitialState() {
        switch context {
        case .sender:
            let viewModels = countriesStoreService.countriesForSender().map { country in
                return SearchItemViewModel(title: country.name, subtitle: country.currency.title, image: country.image)
            }
            state = .loaded(viewModels)
        case .receiver:
            let viewModels = countriesStoreService.countriesForReceiver().map { country in
                return SearchItemViewModel(title: country.name, subtitle: country.currency.title, image: country.image)
            }
            state = .loaded(viewModels)
        }
    }

    private func setupBindings() {
        $searchText
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.search()
            }
            .store(in: &subscriptions)

        viewInputEventPublisher
            .sink { [weak self] viewInputEvent in
                guard let self = self else { return }
                self.proceedViewInputEvent(viewInputEvent)
            }
            .store(in: &subscriptions)
    }

    private func proceedViewInputEvent(_ event: ViewInputEvent) {
        switch event {
        case .textDidChange(let text):
            searchText = text

            if searchText.isEmpty {
                configureInitialState()
            }
        case .cancelButtonClicked:
            configureInitialState()
        case .didSelectItem(let indexPath):
            proceedItemSelection(at: indexPath)

            viewOutputEvent.send(.dismiss)
        }
    }

    private func search() {
        guard case .loaded(let array) = state else {
            return
        }

        let filtered = array.filter({ $0.title.lowercased().contains(searchText.lowercased()) })
        state = .loaded(filtered)
    }

    private func proceedItemSelection(at indexPath: IndexPath) {
        guard case .loaded(let array) = state else {
            return
        }

        let name = array[indexPath.item].title

        switch context {
        case .receiver:
            countriesStoreService.configureReceiverCountry(for: name)
        case .sender:
            countriesStoreService.configureSenderCountry(for: name)
        }
    }
}

extension SearchViewModel {
    enum LoadingState: Equatable {
        case idle
        case loading
        case loaded([SearchItemViewModel])
        case failed(Error)

        static func == (lhs: SearchViewModel.LoadingState, rhs: SearchViewModel.LoadingState) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle):
                return true
            case (.loading, .loading):
                return true
            case (.loaded, .loaded):
                return true
            case (.failed, .failed):
                return true
            default:
                return false
            }
        }
    }
}

extension SearchViewModel {
    enum ViewInputEvent {
        case textDidChange(String)
        case cancelButtonClicked
        case didSelectItem(IndexPath)
    }

    enum ViewOutputEvent {
        case dismiss
    }
}

extension SearchViewModel {
    public enum Context {
        case sender
        case receiver
    }
}
