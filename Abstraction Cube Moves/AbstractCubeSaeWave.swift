import Foundation
import SwiftUI
import WebKit

// MARK: - Протоколы

/// Протокол для состояний загрузки с расширенной функциональностью
protocol AbstractCubeLoadStateRepresentable {
    var type: AbstractCubeLoadState.StateType { get }
    var percent: Double? { get }
    var error: String? { get }

    func isEqual(to other: Self) -> Bool
}

// MARK: - Улучшенная структура состояния загрузки

/// Структура для представления состояний веб-загрузки
struct AbstractCubeLoadState: Equatable, AbstractCubeLoadStateRepresentable {
    // MARK: - Перечисление типов состояний

    /// Типы состояний загрузки с порядковым номером
    enum StateType: Int, CaseIterable {
        case idle = 0
        case progress
        case success
        case error
        case offline

        /// Человекочитаемое описание состояния
        var description: String {
            switch self {
            case .idle: return "Ожидание"
            case .progress: return "Загрузка"
            case .success: return "Успешно"
            case .error: return "Ошибка"
            case .offline: return "Нет подключения"
            }
        }
    }

    // MARK: - Свойства

    let type: StateType
    let percent: Double?
    let error: String?

    // MARK: - Статические конструкторы

    /// Создание состояния простоя
    static func idle() -> AbstractCubeLoadState {
        AbstractCubeLoadState(type: .idle, percent: nil, error: nil)
    }

    /// Создание состояния прогресса
    static func progress(_ percent: Double) -> AbstractCubeLoadState {
        AbstractCubeLoadState(type: .progress, percent: percent, error: nil)
    }

    /// Создание состояния успеха
    static func success() -> AbstractCubeLoadState {
        AbstractCubeLoadState(type: .success, percent: nil, error: nil)
    }

    /// Создание состояния ошибки
    static func error(_ err: String) -> AbstractCubeLoadState {
        AbstractCubeLoadState(type: .error, percent: nil, error: err)
    }

    /// Создание состояния отсутствия подключения
    static func offline() -> AbstractCubeLoadState {
        AbstractCubeLoadState(type: .offline, percent: nil, error: nil)
    }

    // MARK: - Методы сравнения

    /// Пользовательская реализация сравнения
    func isEqual(to other: AbstractCubeLoadState) -> Bool {
        guard type == other.type else { return false }

        switch type {
        case .progress:
            return percent == other.percent
        case .error:
            return error == other.error
        default:
            return true
        }
    }

    // MARK: - Реализация Equatable

    static func == (lhs: AbstractCubeLoadState, rhs: AbstractCubeLoadState) -> Bool {
        lhs.isEqual(to: rhs)
    }
}

// MARK: - Расширения для улучшения функциональности

extension AbstractCubeLoadState {
    /// Проверка текущего состояния
    var isLoading: Bool {
        type == .progress
    }

    /// Проверка успешного состояния
    var isSuccessful: Bool {
        type == .success
    }

    /// Проверка состояния ошибки
    var hasError: Bool {
        type == .error
    }
}

// MARK: - Расширение для отладки

extension AbstractCubeLoadState: CustomStringConvertible {
    /// Строковое представление состояния
    var description: String {
        switch type {
        case .idle: return "Состояние: Ожидание"
        case .progress: return "Состояние: Загрузка (\(percent?.formatted() ?? "0")%)"
        case .success: return "Состояние: Успешно"
        case .error: return "Состояние: Ошибка (\(error ?? "Неизвестная ошибка"))"
        case .offline: return "Состояние: Нет подключения"
        }
    }
}
