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

**Stop ONCE**: Ask "계획을 승인하시겠습니까?" and wait for user approval.

**Approval Keywords**: "ok", "go", "yes", "응", "시작", "하자", "진행", "ㄱㄱ"

**Example**:
```
[Implementation Plan]
1. Modify: lib/features/truck_list/presentation/truck_list_screen.dart (lines 28, 59, 252)
2. Side effects: UI strings will change to use AppLocalizations
3. Verification: Run app and check Korean/English display
4. Rollback: git reset HEAD^ if issues occur
```

### Phase 2: 🚀 Autonomous Execution

**Trigger**: Plan approved (user says "ok", "go", "시작", "하자", etc.).

**Action**:
- Execute the approved plan **WITHOUT ANY INTERRUPTION**
- Make ALL decisions autonomously (variable names, formatting, file structure, etc.)
- **NEVER** ask questions during execution - just do it
- Git commits are handled by hooks - keep working

**CRITICAL RULES (ABSOLUTE)**:
- **ONE APPROVAL = FULL PHASE**: User approves ONCE, you execute ENTIRE phase
- **ZERO INTERRUPTIONS**: Never ask questions mid-execution
- **NO PERMISSION REQUESTS**: Don't ask "Should I...", "Do you want...", "Can I..."
- **JUST DO IT**: Make ALL decisions autonomously based on best practices
- **FULL AUTHORITY**: You are the lead engineer - act like it
- **COMMIT AS YOU GO**: Git commit after each logical step
- **PUSH FREQUENTLY**: Push to GitHub after every 2-3 commits
- Update TodoWrite to show progress (not ask permission)
- Report completion ONLY at the very end

**Phase Completion Criteria**:
- Phase ends when ALL planned tasks are done
- Phase ends when Safety Brake triggers (3 failed attempts)
- Phase does NOT end for trivial questions or small decisions

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

### 💰 Cost Reduction Strategies (Updated 2025-12-28)

#### 1. Prompt Caching (90% Input Token Savings)
- **What**: Cache repetitive input contexts (large files, documentation)
- **How**: Claude Code automatically leverages prompt caching
- **Benefit**: Reduces input token costs by up to 90% for repeated contexts
- **Best Practice**: Keep frequently-referenced files (PROJECT_CONTEXT.md, CLAUDE.md) in context

#### 2. Batch Processing (50% Output Token Savings)
- **What**: Use Batch API for large-scale operations
- **How**: Process multiple tasks asynchronously via Anthropic Batch API
- **Benefit**: 50% reduction in output token costs
- **Use Cases**:
  - Bulk code generation
  - Multiple file refactoring
  - Comprehensive test generation
  - Documentation generation

#### 3. Cursor Direct API Key Usage
- **What**: Use Anthropic API key directly in Cursor
- **How**: Configure Cursor to bypass 20% markup
- **Benefit**: 20% cost savings on Cursor usage
- **Setup**: Add Anthropic API key in Cursor settings

#### 4. Apidog Integration (Query Caching)
- **What**: Cache API specifications locally using Apidog MCP server
- **How**: Integrate Apidog to avoid repeated API spec queries
- **Benefit**: Reduced token usage for repetitive API queries
- **Download**: [Apidog Free Download](https://apidog.com)

#### 5. Token Usage Monitoring
- **Tools**:
  - Anthropic API Dashboard: Track real-time usage
  - Cursor Usage Tracker: Monitor session costs
- **Alert Setup**: Set budget alerts to prevent cost overruns
- **Best Practice**: Review usage weekly

---

### Output Brevity
- **Code Changes**: Show only modified sections, not entire files
- **Diffs**: Use concise format:
  ```dart
  // Before
  - const Text('하드코딩'),

  // After
  + Text(AppLocalizations.of(context)!.localized),
  ```
- **No Redundancy**: Never repeat code already visible in context
- **Summary First**: Lead with executive summary, details on request

### Context Management
- **Compact Often**: If conversation exceeds 20 turns, suggest `/compact`
- **File References**: Use line numbers (`truck_list_screen.dart:28`) instead of full paths
- **Avoid Duplication**: Don't repeat information already in PROJECT_CONTEXT.md
- **Incremental Reads**: Read large files in chunks (offset/limit) when possible

### Tool Usage Efficiency
- **Read Once**: Read files only once per session, cache in memory
- **Grep Over Read**: Use Grep for multi-file searches instead of reading each file
- **Batch Changes**: Group related edits together (single Edit call with multiple changes)
- **Parallel Tools**: Call multiple independent tools in one message (parallel execution)

### Code Generation Optimization
- **Templates**: Reuse code patterns from existing files
- **Incremental**: Build complex features step-by-step, not all-at-once
- **Targeted**: Only generate requested code, avoid "bonus" features
- **DRY Principle**: Extract shared logic to utilities, don't duplicate

---

### 📊 Token Budget Guidelines

**Per Session Target**: < 100,000 tokens (50% of 200k limit)

**High-Cost Operations** (use sparingly):
- Reading entire large files (>500 lines)
- Generating new files from scratch
- Comprehensive refactoring (>10 files)
- Detailed explanations (prefer concise summaries)

**Low-Cost Operations** (optimize for):
- Targeted edits (Edit tool with specific old_string)
- Grep searches (narrow scope with glob/type filters)
- Git operations (commit, push)
- Documentation updates (incremental)

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

### 2025-12-28: Cloud Functions & Token Optimization
- **Token Efficiency**: Batch commits (3 functions → 1 commit) saves 60% output tokens
- **Documentation First**: Write deployment guides BEFORE deploying (prevents repeated queries)
- **Prompt Caching**: Keep CLAUDE.md, PROJECT_CONTEXT.md in context for 90% input savings
- **Incremental Commits**: Commit after each logical step prevents re-generating on interruption
- **Parallel Tool Calls**: Call Read, Grep in parallel when no dependency (2x faster, same tokens)

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
