
# ✅ Commit Message Conventions for Flutter Projects

Follow this guide to keep commit history clean, consistent, and meaningful.

---

## 🔤 Allowed Commit Types (Conventional Commits)

Use **only** the following types:

- `feat`: New features (widgets, services, flows)
- `fix`: Bug fixes (UI issues, logic errors, API problems)
- `refactor`: Code improvements that don't change behavior
- `test`: Adding or updating tests
- `docs`: Documentation changes only (README, code comments)
- `style`: Formatting, theming, naming — no logic changes
- `chore`: Maintenance (deps, configs, assets, CI/CD)

---

## ✍️ Commit Message Format

```

<type>: \<summary of change (max 60 chars)>

* \<bullet point 1>
* \<bullet point 2>
* <...>

```

✅ **Rules**:
- Use lowercase for `<type>`
- Keep summary line short (≤ 60 characters)
- Use bullet points if details are needed
- Group commits by type — don’t mix features and fixes

---

## 📦 Example Commit Plan

```

feat: implement login screen UI

* create login form with validation
* add "Remember Me" checkbox and forgot password link
* apply custom theme to inputs and buttons

feat: setup Firebase authentication

* integrate FirebaseAuth for login
* handle auth errors with snackbar messages

fix: correct layout overflow in profile page

* wrap text in Flexible widget
* adjust avatar size on small screens

refactor: move auth logic to AuthService

* extract logic from UI to /services/auth\_service.dart
* prep for use in signup and password reset

test: add widget test for login form validation

* test input errors and success flow

docs: update README with Firebase setup instructions

* include Android & iOS integration notes
* add dotenv usage and .gitignore tips

style: unify button styles across app

* use consistent elevation and padding

chore: upgrade Flutter SDK and dependencies

* bump firebase\_auth, provider versions
* update min SDK in pubspec.yaml

```

---

## 🛠️ Common Use Cases

| Type     | Typical Contexts                                                             |
|----------|------------------------------------------------------------------------------|
| feat     | new screens, forms, widgets, animations, APIs, state logic                  |
| fix      | layout bugs, crashes, network issues, null safety problems                  |
| refactor | code extraction, architecture cleanups, converting Stateful → Stateless     |
| test     | widget/unit/integration tests using flutter_test or integration_test        |
| docs     | README, getting started, in-code explanations, architecture notes           |
| style    | formatting changes (dartfmt), theming, naming consistency                   |
| chore    | asset updates, pubspec.yaml changes, flutter upgrade, config or CI scripts  |


