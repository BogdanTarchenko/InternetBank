import Foundation

@Observable
final class CreateLoanViewModel {
    let client: Client
    var tariffs: [LoanTariff] = []
    var selectedTariffId: UUID?
    var amountText = ""
    var isLoading = false
    var isSubmitting = false
    var errorMessage: String?

    private let employeeService: IEmployeeService
    var onSuccess: (() -> Void)?

    init(client: Client, employeeService: IEmployeeService) {
        self.client = client
        self.employeeService = employeeService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            tariffs = try await employeeService.fetchLoanTariffs()
            selectedTariffId = tariffs.first?.id
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func submit() async {
        guard let amount = Decimal(string: amountText.replacingOccurrences(of: ",", with: ".")),
              amount > 0 else {
            errorMessage = "Введите сумму"
            return
        }
        isSubmitting = true
        errorMessage = nil
        defer { isSubmitting = false }
        do {
            _ = try await employeeService.createLoan(clientId: client.id, amount: amount, tariffId: selectedTariffId)
            onSuccess?()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
