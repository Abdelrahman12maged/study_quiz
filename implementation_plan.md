# Implementation Plan: Localization & UI Refactoring

This plan outlines the steps to fix the broken localization system and refactor the entire application's UI by breaking down large screens into small, reusable, stateless widgets.

## User Review Required

> [!IMPORTANT]
> This is a massive refactoring that touches the entire UI codebase. All hardcoded English strings will be extracted into `.arb` files, and large screen files will be broken down into dozens of smaller files. 
> Please review the proposed folder structure and localization approach to ensure it meets your expectations before I begin execution.

## Open Questions

1. **Translations**: Would you like me to translate all strings into Arabic (ar) automatically while extracting them, or do you have a specific translation file you want to use?
2. **Naming Convention**: For the small stateless widgets, I will name them logically based on their function (e.g., `capture_cta.dart`, `stats_row.dart`). Are there any specific naming conventions you prefer?

## Proposed Changes

### Phase 1: Setup Localization (`l10n`)
Currently, localization is not properly configured. We will implement the standard `flutter_gen` pipeline.

#### [MODIFY] pubspec.yaml
- Add `generate: true` under the `flutter` section.
- Ensure `flutter_localizations` and `intl` are correctly configured.

#### [NEW] l10n.yaml
- Create configuration for the localization code generator.

#### [NEW] lib/l10n/app_en.arb
- Extract all English strings from the app into this base translation file.

#### [NEW] lib/l10n/app_ar.arb
- Create Arabic translations for all the extracted strings.

#### [MODIFY] lib/main.dart
- Update the `MaterialApp` to use `AppLocalizations.delegate` and supported locales instead of hardcoded delegates.

---

### Phase 2: Refactor Screens into Small Widgets

We will systematically go through each feature, break down the `_Screen` file into smaller stateless components, and place them inside the `widgets/` folder of that feature. 

During this process, we will also replace all hardcoded strings with `AppLocalizations.of(context)!.stringKey`.

#### 1. Home Feature
- **Target**: `lib/features/home/presentation/screens/home_screen.dart`
- **New Files in `home/presentation/widgets/`**:
  - `mobile_home_layout.dart`
  - `tablet_home_layout.dart`
  - `capture_cta.dart`
  - `stats_row.dart`
  - `stat_card.dart`
  - `session_list_item.dart`

#### 2. History Feature
- **Target**: `lib/features/history/presentation/screens/history_screen.dart`
- **New Files in `history/presentation/widgets/`**:
  - `history_header.dart`
  - `history_list_layout.dart`
  - `history_grid_layout.dart`
  - `history_session_card.dart`

#### 3. Processing Feature
- **Target**: `lib/features/processing/presentation/screens/processing_screen.dart`
- **New Files in `processing/presentation/widgets/`**:
  - `animated_progress_view.dart`
  - `processing_stage_checklist.dart`

#### 4. Auth Feature
- **Target**: `sign_in_screen.dart`, `sign_up_screen.dart`
- **New Files in `auth/presentation/widgets/`**:
  - `auth_form_fields.dart`
  - `auth_submit_button.dart`
  - `social_login_buttons.dart`

#### 5. Capture Feature
- **Target**: `capture_screen.dart`
- **New Files in `capture/presentation/widgets/`**:
  - `camera_preview_widget.dart`
  - `capture_controls.dart`
  - `image_confirmation_dialog.dart`

#### 6. Quiz Feature
- **Target**: `quiz_screen.dart`, `results_screen.dart`
- **New Files in `quiz/presentation/widgets/`**:
  - `question_card.dart`
  - `answer_option_tile.dart`
  - `quiz_progress_header.dart`
  - `results_summary_card.dart`
  - `results_action_buttons.dart`

#### 7. Settings Feature
- **Target**: `settings_screen.dart`
- **New Files in `settings/presentation/widgets/`**:
  - `theme_toggle_tile.dart`
  - `language_selector_tile.dart`
  - `logout_button.dart`

#### 8. Onboarding Feature
- **Target**: `onboarding_screen.dart`
- **New Files in `onboarding/presentation/widgets/`**:
  - `onboarding_page_content.dart`
  - `onboarding_navigation_controls.dart`

## Verification Plan

### Automated Tests
- Run `flutter pub get` and `flutter gen-l10n` to ensure code generation succeeds.
- Run `flutter analyze` to verify that breaking down widgets didn't introduce syntax errors, state management bugs, or unused imports.

### Manual Verification
- After completion, ask the user to switch languages to Arabic to verify UI layout responsiveness (RTL) and translation accuracy.
- Verify that navigating between the newly refactored screens functions seamlessly.
