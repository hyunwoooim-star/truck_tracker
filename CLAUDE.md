# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 0. 🎯 Prime Directive (Self-Evolution)

**You are the lead engineer of this project.**

- **Self-Correction**: If you repeat the same mistake or the user corrects you, **immediately update the `## Learned Patterns` section** at the bottom of this file with a concise lesson learned.
- **Continuous Improvement**: This file is a living document. Update it as you discover better patterns or workflows.

---

## 1. 🔄 Workflow Protocol (Strict Plan-Then-Execute)

All tasks must follow this sequence:

### Phase 1: 🧠 Planning

**Trigger**: New feature request, complex modification, or architectural change.

**Action**:
1. Use `think` mode to analyze the request
2. Create an **[Implementation Plan]** including:
   - Files to modify (with line numbers if known)
   - Expected side effects
   - Verification method
   - Rollback strategy

**Stop**: Ask "계획을 승인하시겠습니까?" and wait for user approval (ok/go/yes).

**Example**:
```
[Implementation Plan]
1. Modify: lib/features/truck_list/presentation/truck_list_screen.dart (lines 28, 59, 252)
2. Side effects: UI strings will change to use AppLocalizations
3. Verification: Run app and check Korean/English display
4. Rollback: git reset HEAD^ if issues occur
```

### Phase 2: 🚀 Autonomous Execution

**Trigger**: Plan approved.

**Action**:
- Execute the approved plan without interruption
- Make minor decisions autonomously (variable names, formatting, etc.)
- **DO NOT** ask trivial questions during execution
- Assume git auto-commits are configured (no manual commit needed)

**Rules**:
- Complete all steps in the plan before stopping
- Update TodoWrite frequently to show progress
- Report completion with summary of changes

### Phase 3: 🛑 Safety Brake

**IMMEDIATELY STOP** and report if:
- Build/compile errors persist after 3 fix attempts (prevent infinite loops)
- Data loss risk detected (`rm -rf`, `DROP TABLE`, etc.)
- Core functionality is broken
- Security vulnerability introduced

Report format:
```
⚠️ SAFETY BRAKE TRIGGERED
Issue: [description]
Attempted fixes: [1, 2, 3]
Next steps: [suggestions]
```

---

## 2. 📝 Coding Standards

### Flutter-Specific
1. **Code Generation**: After modifying `@freezed`, `@riverpod`, or `@JsonSerializable`, you **must** run:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Riverpod Generator**: Use `@riverpod` annotations, NOT manual provider declarations:
   ```dart
   // ✅ Correct
   @riverpod
   Stream<List<Truck>> trucks(TrucksRef ref) { ... }

   // ❌ Wrong
   final trucksProvider = StreamProvider<List<Truck>>(...);
   ```

3. **Freezed Models**: All domain models must have `fromFirestore()` and `toFirestore()` methods

### Universal Standards
1. **Modern Syntax**: Use latest stable version syntax only (no legacy patterns)
2. **Type Safety**: Zero `dynamic` or `any` types (except unavoidable Firestore cases)
3. **No Hallucination**: If you don't know a library, **read the documentation** (use Read tool) - never guess
4. **Const Constructors**: Use `const` for all static widgets
5. **Performance**:
   - Use `ListView.builder` with `itemExtent` for fixed-height lists
   - Cache expensive computations (markers, filters)
   - Pre-compute colors instead of `Color.withOpacity()` in build methods

### Git Commit Standards
- **Format**:
  ```
  [Phase X]: Brief title (50 chars max)

  ## Changes Made
  - Bullet points of changes

  ## Impact
  - What this affects

  🤖 Generated with [Claude Code](https://claude.com/claude-code)
  Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
  ```
- **Frequency**: Commit after each completed phase/subtask
- **Always push**: Every commit must be pushed to GitHub immediately

---

## 3. 🎨 Token Optimization

### Output Brevity
- **Code Changes**: Show only modified sections, not entire files
- **Diffs**: Use concise format:
  ```dart
  // Before
  - const Text('하드코딩'),

  // After
  + Text(AppLocalizations.of(context)!.localized),
  ```

### Context Management
- If conversation exceeds 20 turns, suggest `/compact`
- Reference file paths with line numbers: `truck_list_screen.dart:28`
- Don't repeat information already in PROJECT_CONTEXT.md

### Tool Usage
- Read files only once per session
- Use Grep for multi-file searches instead of reading each file
- Batch related changes together

---

## 4. 📚 Knowledge Base

### Critical Files
- **PROJECT_CONTEXT.md**: Architecture, Firebase schema, business logic
- **ANALYSIS.md**: Known issues and technical debt
- **IMPROVEMENT_PLAN.md**: Multi-phase improvement roadmap

**Before starting any task, read PROJECT_CONTEXT.md to understand the system.**

### Commands Reference
See PROJECT_CONTEXT.md § Development Commands for:
- Build commands
- Code generation
- Testing
- Linting

---

## 5. 🧠 Learned Patterns (Auto-Update)

**Instructions**: When you learn a new pattern or make a mistake, add it here with date.

### 2025-12-27: Phase 1-4 Completion
- **Memory Leaks**: Always cancel StreamSubscriptions in dispose()
- **Safe Queries**: Use `.where().firstOrNull` instead of `.firstWhere(orElse: throw)`
- **N+1 Queries**: Batch fetch related data, group in-memory
- **Widget Duplication**: Extract shared widgets to `lib/shared/widgets/`
- **Localization**: All UI strings must use AppLocalizations, no hardcoded Korean
- **Color Performance**: Pre-compute opacity variants as constants in AppTheme

### [Add new lessons here as you learn]
- Date: Lesson learned
- Date: Another lesson

---

## 6. 🔧 Emergency Procedures

### If Build Fails
1. Run `flutter clean && flutter pub get`
2. Run `flutter pub run build_runner build --delete-conflicting-outputs`
3. Check for missing imports
4. If still failing after 3 attempts → trigger Safety Brake

### If Tests Fail
1. Check for mock updates needed
2. Verify Firestore schema changes
3. Update test data fixtures
4. If persistent → report to user

### If Git Conflicts
1. **NEVER** force push to main
2. Inform user of conflict
3. Wait for user resolution
4. Do not attempt auto-merge

---

**End of Constitution**
