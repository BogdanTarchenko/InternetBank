import SwiftUI

struct TakeLoanView: View {
    @Bindable var viewModel: TakeLoanViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Layout.formSpacing) {
                    Text(Strings.amountLabel)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.leading, Layout.fieldLabelLeading)
                    TextField(Strings.amountPlaceholder, text: $viewModel.amount)
                        .keyboardType(.decimalPad)
                        .padding(.horizontal, Layout.fieldInnerHorizontal)
                        .padding(.vertical, Layout.fieldInnerVertical)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: Layout.fieldCornerRadius))

                    Text(Strings.currencyLabel)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                        .padding(.leading, Layout.fieldLabelLeading)
                    Picker("", selection: $viewModel.currency) {
                        Text("RUB").tag("RUB")
                        Text("USD").tag("USD")
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, Layout.fieldLabelLeading)

                    if let message = viewModel.errorMessage {
                        errorBlock(message: message)
                    }

                    Button(action: { Task { await viewModel.submit() } }) {
                        HStack {
                            if viewModel.isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text(Strings.submitButtonTitle)
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Layout.buttonVerticalPadding)
                        .background(LinearGradient.appAccent)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: Layout.buttonCornerRadius))
                    }
                    .disabled(viewModel.isSubmitting)
                }
                .padding(Layout.cardPadding)
                .background(Color(uiColor: .systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
                .shadow(color: .black.opacity(Layout.cardShadowOpacity), radius: Layout.cardShadowRadius, x: 0, y: Layout.cardShadowY)
                .padding(.horizontal, Layout.screenHorizontalPadding)
                .padding(.vertical, Layout.screenVerticalPadding)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle(Strings.title)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func errorBlock(message: String) -> some View {
        HStack(alignment: .center, spacing: Layout.errorBlockSpacing) {
            RoundedRectangle(cornerRadius: Layout.errorStripCornerRadius)
                .fill(Appearance.errorAccent)
                .frame(width: Layout.errorStripWidth, height: Layout.errorStripHeight)
            Image(systemName: Strings.errorIconName)
                .font(.system(size: Layout.errorIconSize))
                .foregroundStyle(Appearance.errorAccent)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, Layout.errorBlockInnerPadding)
        .padding(.vertical, Layout.errorBlockVerticalPadding)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: Layout.errorBlockCornerRadius))
    }
}

private extension TakeLoanView {
    enum Layout {
        static let screenHorizontalPadding: CGFloat = 16
        static let screenVerticalPadding: CGFloat = 16
        static let cardPadding: CGFloat = 16
        static let formSpacing: CGFloat = 16
        static let fieldLabelLeading: CGFloat = 8
        static let fieldInnerHorizontal: CGFloat = 8
        static let fieldInnerVertical: CGFloat = 12
        static let fieldCornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let cardShadowOpacity: Double = 0.04
        static let cardShadowRadius: CGFloat = 8
        static let cardShadowY: CGFloat = 2
        static let errorBlockSpacing: CGFloat = 12
        static let errorStripCornerRadius: CGFloat = 6
        static let errorStripWidth: CGFloat = 4
        static let errorStripHeight: CGFloat = 32
        static let errorIconSize: CGFloat = 14
        static let errorBlockInnerPadding: CGFloat = 8
        static let errorBlockVerticalPadding: CGFloat = 12
        static let errorBlockCornerRadius: CGFloat = 10
        static let buttonVerticalPadding: CGFloat = 16
        static let buttonCornerRadius: CGFloat = 12
    }
    enum Appearance {
        static let errorAccent = Color(red: 0.85, green: 0.35, blue: 0.25)
    }
    enum Strings {
        static let title = "Взять кредит"
        static let amountLabel = "Сумма"
        static let amountPlaceholder = "0"
        static let currencyLabel = "Валюта"
        static let submitButtonTitle = "Оформить"
        static let errorIconName = "exclamationmark.triangle.fill"
    }
}
