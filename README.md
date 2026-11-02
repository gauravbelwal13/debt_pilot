# DebtPilot

**A personal debt management and repayment planning app built with Flutter.**

DebtPilot is designed to help users organize their debts, keep track of scheduled repayments, monitor payment activity, and understand their progress toward becoming debt-free.

The project focuses on a clean mobile experience, local data persistence, reusable UI components, and a feature-oriented Flutter architecture.

> **Project status:** Active development. The UI and local database foundation are in place. Some dashboard and analytics data is currently mocked and will be connected to the database in a future development phase.

---

## Features

### Debt Management
- Add debts using a guided multi-step flow.
- Organize debts by type and lender.
- View debt information and details.
- Support active and completed debt statuses in the data model.
- Update and delete debt records through the database layer.

### Payment Tracking
- Store scheduled payments for individual debts.
- Generate and insert multiple scheduled payment records.
- Track payment status.
- Record payment dates.
- Retrieve upcoming and date-specific payments.

### Calendar
- Calendar screen for navigating scheduled payments.
- Monthly and weekly calendar views.
- Agenda-style payment presentation.
- Selected-date payment summaries.

### Insights and Analytics
- Debt overview cards.
- Outstanding debt trend charts.
- Monthly repayment burden charts.
- Debt category breakdown.
- Projected debt-free date.
- Extra monthly payment calculator.

**Note:** Insights and Home dashboard figures currently use sample data. Live database integration is planned.

### User Experience
- Guided debt entry flow.
- Reusable custom widgets.
- Profile avatar selection.
- Navigation drawer and bottom navigation.
- Light theme and reusable design tokens.

---

## Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI development |
| Dart | Application programming language |
| Riverpod | State management foundation |
| GoRouter | Declarative navigation |
| Drift | Reactive SQLite database layer |
| SQLite | Local data persistence |
| fl_chart | Charts and data visualization |
| Google Fonts | Typography |
| intl | Date and currency formatting |
| UUID | Unique record identifiers |
| flutter_secure_storage | Secure local storage capability |

---

## Architecture

The project follows a feature-oriented structure, separating application configuration, shared utilities, database code, and feature-specific UI and domain models.

```text
lib/
├── main.dart
│
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│
├── core/
│   ├── constants/
│   ├── errors/
│   ├── extensions/
│   ├── services/
│   ├── utils/
│   └── widgets/
│
├── data/
│   └── database/
│       ├── app_database.dart
│       ├── daos/
│       └── tables/
│
└── features/
    ├── about/
    ├── calendar/
    │   ├── domain/
    │   └── presentation/
    ├── debts/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── home/
    ├── insights/
    │   ├── domain/
    │   └── presentation/
    ├── onboarding/
    └── settings/
```

### Architectural approach

- **App:** Application setup, routing, and theming.
- **Core:** Shared widgets, utilities, constants, and common services.
- **Data:** Local database configuration, tables, and DAOs.
- **Features:** Individual application modules with their own presentation and domain code.

The structure is designed to support further separation of data, domain, and presentation responsibilities as the application develops.

---

## Local Database

DebtPilot uses **Drift with SQLite** for local persistence.

### Database tables

**Debts**

Stores the primary debt information:

- Debt ID
- Debt type
- Lender
- Original borrowed amount
- Start date
- Duration
- Monthly payment
- First payment date
- Status
- Created and updated timestamps

**Scheduled Payments**

Stores individual repayment records:

- Payment ID
- Associated debt ID
- Due date
- Payment amount
- Paid status
- Actual payment date
- Creation timestamp

### DAO operations

| DAO | Supported operations |
|---|---|
| DebtDao | Insert, retrieve, watch, update, delete |
| ScheduledPaymentDao | Insert, batch insert, retrieve, watch, mark paid/unpaid, delete |

The database layer also supports reactive queries using Drift streams, allowing the UI to observe database changes when connected.

---

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android SDK or another supported Flutter platform

### Installation

Clone the repository:

```bash
git clone https://github.com/gauravbelwal13/debt_pilot.git
```

Navigate to the project:

```bash
cd debt_pilot
```

Install dependencies:

```bash
flutter pub get
```

Generate Drift database code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Run the application:

```bash
flutter run
```

Run static analysis:

```bash
flutter analyze
```

---

## Screenshots

Screenshots will be added as the application UI and database integration progress.

| Screen | Preview |
|---|---|
| Home Dashboard | Coming soon |
| Add Debt Flow | Coming soon |
| Debt Details | Coming soon |
| Calendar | Coming soon |
| Insights | Coming soon |
| Settings | Coming soon |

---

## Roadmap

- [x] Flutter project setup and application routing
- [x] Reusable UI component foundation
- [x] Debt entry UI flow
- [x] Drift database setup
- [x] Debt and scheduled payment tables
- [x] Debt and payment DAO operations
- [x] Calendar and Insights UI
- [ ] Connect debt creation flow to database persistence
- [ ] Integrate Riverpod with database streams
- [ ] Replace Home dashboard mock data
- [ ] Replace Insights mock data
- [ ] Implement payment reminders and notifications
- [ ] Add payment history and repayment updates
- [ ] Add document and receipt attachments
- [ ] Add database backup and restore

---

## Project Goals

DebtPilot is being developed as a practical demonstration of Flutter application development, including:

- Feature-oriented project organization.
- Reactive local database operations.
- State management with Riverpod.
- Navigation with GoRouter.
- Reusable and maintainable UI components.
- Data visualization and financial calculations.

---

## Author

**Gaurav Belwal**

Flutter Developer | Mobile Application Development

GitHub: [@gauravbelwal13](https://github.com/gauravbelwal13)

---

*DebtPilot is an independent development project. It is not a financial institution or a source of financial advice.*
