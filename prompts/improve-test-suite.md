# Task: Audit, Streamline, and Reorganize the Test Suite

## Objective

Audit and improve the project's existing test suite.

The goal is **not to minimize the number of tests**. The goal is to create a **small, high-value, maintainable test suite with clear coverage, strong assertions, and minimal redundant coverage**.

Every retained test should have a clear reason to exist: it should protect meaningful behavior, a public contract, an important regression, an important boundary, or another realistic failure mode.

You are allowed to:

* Remove redundant or genuinely low-value tests.
* Strengthen weak tests.
* Rewrite brittle or implementation-coupled tests.
* Merge or parameterize overlapping tests.
* Rename tests and files.
* Move tests between files or test layers.
* Reorganize fixtures, helpers, and test data.
* Create new test files.
* Split or consolidate existing test files.
* Add tests for meaningful coverage gaps.
* Add tests that expose existing production bugs.
* Remove obsolete test utilities and fixtures.

You must **not change production behavior merely to make tests easier to remove or easier to pass**.

If you discover a production bug, distinguish it explicitly from a test-suite problem. Do not silently alter production behavior to accommodate the tests unless fixing production bugs is explicitly within the scope of the task.

---

# Core Principle

Optimize for:

> **Confidence per test, not the fewest possible tests.**

A test earns its place by protecting meaningful behavior or a realistic failure mode.

For every test, ask:

> **"If the production code were accidentally broken in a plausible way, would this test actually fail?"**

If the answer is clearly no, consider strengthening, replacing, consolidating, or removing the test.

Do not confuse code execution with meaningful coverage.

A test that executes code but would continue to pass despite a meaningful regression is weak coverage.

Likewise, do not assume that a test is bad simply because it currently fails. A test can be valuable precisely because it exposes a real defect in the current implementation.

---

# Phase 1 — Establish a Baseline

Before modifying anything:

1. Inspect the project structure.
2. Identify:

   * Test frameworks.
   * Test runners.
   * Test configuration.
   * Unit, integration, end-to-end, and other test layers.
   * Test fixtures.
   * Test helpers/utilities.
   * Shared test data.
   * Mocking infrastructure.
   * Coverage tooling.
   * CI-related test commands.
3. Determine the canonical command(s) for running the relevant test suite.
4. Run the existing relevant test suite.
5. Record, where tooling permits:

   * Number of tests.
   * Passing/failing tests.
   * Test runtime.
   * Coverage.
   * Existing warnings/errors.
6. Preserve enough baseline information to compare the final suite against the original.
7. Do not attribute pre-existing failures to your changes.

Do not modify tests during this phase.

---

# Phase 2 — Understand the Existing Suite

Inspect the **entire existing test suite** before making deletion decisions.

Do not judge tests solely from their names.

For each test, determine:

* What behavior or contract is being tested?
* What plausible production failure would cause it to fail?
* Is that failure meaningful?
* Would the test actually fail for that failure?
* Are the assertions strong enough?
* Is the expected result genuinely derived from the behavior being tested?
* Or is the expected result effectively guaranteed by the setup?
* Is the behavior already covered elsewhere?
* Does the test provide unique failure detection?
* Is it testing observable behavior or implementation details?
* Is it unnecessarily coupled to the current implementation?
* Is it essentially a copy or minor variant of another test?
* Does its particular setup exercise a materially different execution path?
* Does it protect an important business rule, contract, integration, regression, security property, or boundary?

When useful, group tests by the behavior they protect rather than by their current file location.

---

# Phase 3 — Evaluate Test Value

Be particularly skeptical of tests that are effectively guaranteed to pass.

Potential examples include:

* Assertions that are trivially true from the setup.
* `assert result is not None` where almost any implementation would satisfy it.
* Tests of simple getters/setters with no meaningful logic.
* Tests where every dependency is mocked and the test only verifies that mocks were called.
* Tests where the mock setup effectively forces the expected result.
* Tests that merely reproduce the implementation in test form.
* Tests with assertions too weak to catch realistic regressions.
* Tests that only demonstrate that code executes.
* Tests added primarily for code coverage.
* Tests whose expected outcome is completely obvious from their setup.
* Tests that test framework/library behavior rather than project behavior.

However:

**Do not assume that a simple test is worthless.**

A simple test should be retained if it protects an important contract or realistic regression.

Judge tests by **failure detection**, not complexity.

---

# Phase 4 — Identify Redundancy

Look for:

* Multiple tests verifying exactly the same behavior.
* Different test names with effectively identical assertions.
* Parameterized cases that do not represent meaningfully different scenarios.
* Repeated coverage across test files.
* Repeated coverage across test layers.
* Unit tests duplicating meaningful behavior already protected by integration tests.
* Tests that verify implementation details instead of observable behavior.
* Fixture/setup combinations exercising the same meaningful scenario.
* Tests made redundant by later code evolution.
* Tests of framework/library behavior rather than project behavior.
* Multiple cases that could be represented more clearly as one parameterized test.
* Broad tests that duplicate several focused tests.
* Tests whose assertions are technically valid but too weak to detect realistic regressions.

## Critical redundancy rule

**Never remove a test merely because another test looks similar.**

Before removing a test as redundant, establish that:

1. The meaningful behavior is already covered.
2. The relevant failure mode is already covered.
3. The removed test does not exercise a materially different execution path.
4. The remaining test would fail for the regression the removed test was intended to catch.

If these conditions cannot be established, keep the test or classify it as difficult to determine.

---

# Phase 5 — Identify Missing Coverage

Look for meaningful gaps including:

* Important business rules with no direct protection.
* Untested error paths.
* Important edge cases.
* Boundary conditions.
* Null/empty/missing/invalid inputs.
* Authorization and permission scenarios.
* Important state transitions.
* Data integrity requirements.
* Important integration boundaries.
* Known regression scenarios.
* Likely failure modes.
* Public API behavior lacking adequate protection.
* Distinct execution paths with materially different failure modes.

Only add tests when they provide **meaningful additional confidence**.

Do not add tests merely to increase:

* Test count.
* Code coverage percentage.
* Number of assertions.
* Number of parameter combinations.

Do not add tests for trivial behavior, framework behavior, or implementation details unless there is a demonstrated reason.

---

# Phase 6 — Tests for Existing Bugs

You are explicitly allowed to add tests that **fail against the current implementation** when your analysis shows that the implementation violates the intended behavior, contract, business rule, or other meaningful requirement.

A failing test is **not automatically a bad test**.

If you identify meaningful behavior that is currently implemented incorrectly:

1. Plan a test that accurately expresses the intended behavior; add it in Phase 9 after saving the audit.
2. It is acceptable and expected for that test to fail against the current implementation.
3. Clearly identify the underlying production defect.
4. Do not weaken, remove, or alter the test merely to make the suite pass.
5. Do not change production code solely to make the new test pass unless production fixes are explicitly within the scope of this task.
6. Distinguish between:

   * A test that fails because the test itself is incorrect.
   * A test that fails because its setup is broken.
   * A test that correctly fails because the current production implementation is defective.

The expected reasoning for such a test is:

> **"This test should be added because X is currently implemented incorrectly, X represents meaningful expected behavior, and failure of X represents a real production defect/regression."**

Do not use the current implementation as the definition of correct behavior when the implementation itself is what is being evaluated.

The test should express the intended contract.

If project conventions require the final suite to be green, do not silently remove or weaken a legitimate bug-exposing test. Report the failing test and underlying production defect explicitly.

---

# Phase 7 — Preserve Important Coverage

Be conservative about removing tests that cover:

* Critical business rules.
* Important edge cases.
* Error handling.
* Security or authorization.
* Data integrity.
* Known regressions.
* Boundary conditions.
* Important integrations.
* Expensive or dangerous-to-break behavior.
* Public APIs and contracts.
* Distinct execution paths with different failure modes.

Similarity of assertions is not sufficient justification for deletion.

---

# Phase 8 — Create an Audit Markdown File Before Editing

Before modifying the suite, create `test-suite-audit.md` in the project root and write the structured audit to that file. Include the baseline commands and results from Phase 1, followed by the classifications below. An audit provided only in chat does not satisfy this requirement.

If multiple AI agents collaborate, the coordinating agent must consolidate their findings into this single audit file before any agent modifies the suite. Preserve the original audit decisions and append any later discoveries or changes in reasoning.

Classify relevant tests and files into:

### 1. Tests to keep

Explain the unique value and failure mode protected.

### 2. Tests to remove

Identify the exact replacement/covering test(s), or explain why the test provides insufficient meaningful value.

### 3. Tests to strengthen

Explain why the current assertions can pass despite an incorrect implementation.

### 4. Tests to merge/consolidate

Explain why the cases overlap and how consolidation preserves meaningful failure modes.

### 5. Tests to rewrite

Explain whether they are brittle, implementation-coupled, unclear, or otherwise poorly designed.

### 6. Tests to add

Identify the missing behavior and why failure would represent a meaningful regression.

This category includes both:

* Missing coverage where the current implementation is correct.
* Missing coverage where the current implementation is incorrect and the new test should expose the defect.

### 7. Tests to rename

Identify names that fail to communicate observable behavior or expected outcomes.

### 8. Tests/files to move or reorganize

Explain why the new location improves discoverability or maintainability.

### 9. Files to rename, split, or consolidate

Explain the structural improvement.

### 10. Coverage gaps intentionally not addressed

Explain why they were left unresolved.

### 11. Difficult-to-classify tests

Do not delete these without strong justification.

### 12. Existing production defects exposed by tests

List identified production defects and the tests proposed to expose them.

For every proposed deletion justified by redundancy, use this reasoning:

> **"This test can be removed because X is already covered by Y, and the removed test does not exercise a distinct failure mode."**

For every proposed addition:

> **"This test should be added because X is currently not covered, and failure of X would represent a meaningful regression."**

For a test exposing an existing bug:

> **"This test should be added because X is currently implemented incorrectly, X represents meaningful expected behavior, and failure of X represents a real production defect."**

For every proposed strengthening:

> **"This test should be strengthened because it currently passes for implementations that could be incorrect in X way."**

For significant restructuring:

> **"These tests/files should be reorganized because X; the new structure makes Y easier to understand, discover, or maintain."**

Do not begin deleting tests simply because they appear redundant during initial inspection. Complete and save `test-suite-audit.md` first.

---

# Phase 9 — Modify the Test Suite

After completing and saving `test-suite-audit.md`, implement the improvements.

You may:

* Delete redundant/low-value tests.
* Merge duplicate tests.
* Strengthen weak assertions.
* Convert meaningful similar cases into parameterized tests.
* Rewrite brittle tests.
* Remove unnecessary implementation coupling.
* Rename tests.
* Rename test files.
* Move tests.
* Create test files.
* Split large unrelated test files.
* Consolidate unnecessarily fragmented files.
* Move tests to more appropriate test layers.
* Add meaningful missing coverage.
* Add tests exposing existing production defects.
* Improve test names.
* Improve organization.
* Improve fixtures and helpers.
* Remove obsolete fixtures/utilities.
* Remove empty or obsolete test files.

Favor assertions about **observable outcomes and meaningful behavior**.

Avoid assertions that merely prove implementation mechanics.

Do not optimize for the lowest possible test count.

---

# Phase 10 — Validate New and Strengthened Tests Adversarially

For every test that is added or substantially strengthened, perform an adversarial check.

Ask:

> **"What plausible incorrect implementation should this test catch?"**

Then verify that the test would actually fail for that implementation.

Consider realistic regressions such as:

* Returning the wrong value.
* Omitting important validation.
* Accepting invalid input.
* Rejecting valid input.
* Skipping an important state transition.
* Applying the wrong permission rule.
* Persisting incorrect data.
* Returning stale data.
* Failing to handle an error.
* Calling the wrong integration.
* Producing an incorrect public API response.
* Mishandling an important boundary condition.

If the test would still pass despite the proposed regression, its assertions are not strong enough.

Strengthen or replace it.

For tests that expose existing bugs, perform the inverse check:

> **"Does this test express the intended behavior independently of the current buggy implementation?"**

Do not make the expected result conform to the current implementation simply because that makes the test pass.

---

# Phase 11 — Reorganize for Clarity

The final test suite should make it obvious to a developer where to find or add a test.

You may reorganize around:

* Behavior.
* Domain concepts.
* Features.
* Responsibilities.
* Appropriate test layers.

You may:

* Rename tests.
* Rename files.
* Move tests between files.
* Create files.
* Split large files.
* Consolidate fragmented files.
* Move tests to more appropriate layers.
* Rename fixtures/helpers/test data.
* Remove misleading names.
* Improve grouping and ordering.
* Update imports and references.
* Remove obsolete files.

Use existing project conventions where they are good.

If existing organization is inconsistent or clearly problematic, establish a **simple, coherent structure** rather than preserving historical organization for its own sake.

Do not introduce unnecessary organizational complexity.

Test names should describe:

> **Observable behavior + expected outcome**

rather than implementation details.

---

# Important Constraints

## Do not:

* Change production behavior merely to make tests easier to remove.
* Remove a test solely because its assertions resemble another test.
* Optimize for the lowest possible test count.
* Sacrifice meaningful edge-case coverage.
* Sacrifice regression coverage.
* Replace valuable unit tests with expensive end-to-end tests without a good reason.
* Add tests merely to increase coverage percentage.
* Add tests for trivial behavior.
* Add tests for framework/library behavior.
* Add tests solely to execute code.
* Preserve tests merely because they technically execute code.
* Keep tests merely because they already exist.
* Delete uncertain tests without strong evidence.
* Assert implementation details when observable behavior can be tested instead.
* Introduce unnecessary architectural or organizational complexity.
* Modify production behavior simply to accommodate the test-suite cleanup.
* Weaken or remove a legitimate bug-exposing test merely because it currently fails.

## Do:

* Optimize for confidence per test.
* Preserve meaningful failure modes.
* Preserve known regressions.
* Preserve important business rules.
* Preserve security and authorization behavior.
* Preserve important integrations.
* Preserve important boundaries.
* Strengthen weak assertions.
* Prefer observable behavior.
* Prefer distinct failure modes over duplicate assertions.
* Use parameterization when it genuinely improves clarity.
* Keep the final suite understandable to a developer unfamiliar with its history.
* Report uncertainty rather than making unjustified deletions.
* Add tests for meaningful behaviors that are currently missing, even when the current implementation is incorrect.
* Treat legitimate failing tests as valuable when they expose real production defects.

---

# Phase 12 — Final Verification

After all changes:

1. Run the full relevant test suite.
2. Confirm all remaining tests pass, except for explicitly documented failures caused by existing production defects exposed by legitimate tests.
3. Confirm all newly added tests pass or are correctly failing because they expose documented production defects.
4. Compare test count before and after.
5. Compare coverage before and after where tooling allows.
6. Compare test runtime where practical.
7. Identify any meaningful coverage that was lost.
8. Confirm newly added tests represent genuinely new protection.
9. Confirm strengthened tests would fail for their intended regression.
10. Confirm bug-exposing tests express the intended behavior independently of the current implementation.
11. Look again for tests that remain obviously redundant or weak.
12. Verify renamed/moved files and tests have all references updated.
13. Check for orphaned files.
14. Check for empty/obsolete test files.
15. Check for obsolete fixtures and helpers.
16. Review the final suite for consistency.
17. Review the final suite for discoverability.
18. Review whether the final structure is simpler and more coherent than before.
19. Do not declare success merely because all tests pass.
20. Do not declare failure merely because a correctly written test exposes a pre-existing production bug.

A successful result is one where the suite provides **better intentional confidence**, not merely fewer tests.

---

# Final Report

After final verification, create `test-suite-final-report.md` in the project root. Write a concise but complete report of the actual changes and verification results, using the sections below. Keep it separate from `test-suite-audit.md` so the initial assessment and final outcome can be compared. A report provided only in chat does not satisfy this requirement.

If multiple AI agents collaborate, the coordinating agent must consolidate their changes, verification results, and unresolved concerns into this single final report file. In the final chat response, link to both Markdown files and briefly summarize the outcome.

## Baseline

* Tests before.
* Tests after.
* Initial failures, if any.
* Final failures.
* Coverage before/after, if available.
* Runtime before/after, if available.

## Changes

* Tests removed.
* Tests added.
* Tests added specifically to expose existing production bugs.
* Tests strengthened.
* Tests merged/consolidated.
* Tests rewritten.
* Tests renamed.
* Files created.
* Files removed.
* Files renamed.
* Tests moved/reorganized.
* Fixtures/helpers removed or changed.

## Coverage

* Important coverage intentionally preserved.
* Important new coverage added.
* Meaningful coverage lost, if any.
* Coverage gaps discovered but intentionally left unresolved.

## Quality

* Major redundancy removed.
* Weak assertions strengthened.
* Implementation-coupled tests improved.
* Important failure modes preserved.
* Important structural improvements.

## Existing Defects

For every legitimate bug-exposing test that remains failing, report:

* The test.
* The intended behavior.
* The current incorrect behavior.
* Why the test correctly represents the intended contract.
* Why the failure is a production defect rather than a bad test.
* Whether fixing the production defect is recommended separately.

## Remaining Concerns

Explicitly list:

* Remaining questionable tests.
* Remaining potentially redundant tests.
* Remaining weak tests.
* Difficult-to-classify tests.
* Coverage gaps that should be addressed separately.
* Production bugs or suspicious behavior discovered.
* Any verification that could not be performed.

Do not hide uncertainty.

---

# Success Criteria

The task is successful when:

* Every retained test has a defensible reason to exist.
* Important behavior remains protected.
* Important regression and edge-case coverage is preserved.
* Meaningful coverage gaps are addressed where appropriate.
* Weak tests have been strengthened or removed.
* Redundant tests have been consolidated or removed where justified.
* New tests protect genuinely meaningful behavior.
* Tests focus on observable behavior rather than implementation mechanics.
* Tests exposing existing bugs accurately describe the intended behavior and are not weakened merely to make the suite green.
* The suite is easier to understand and navigate.
* The organization is coherent without unnecessary complexity.
* The full relevant suite passes, except for explicitly documented failures caused by existing production defects exposed by legitimate tests.
* Before/after impact is documented.
* Remaining uncertainties and coverage gaps are explicitly reported.
* `test-suite-audit.md` exists in the project root and was completed before any test-suite changes.
* `test-suite-final-report.md` exists in the project root and documents the actual changes, final verification results, and remaining concerns.

Do **not** equate success with a smaller test count.

The desired outcome is:

> **A more intentional test suite where every test has a clear reason to exist, redundant and low-value tests are removed, meaningful gaps are filled, assertions detect plausible regressions, existing defects are exposed rather than encoded as expected behavior, and the structure makes it obvious where a developer should look when adding or debugging a test.**

The fundamental rules are:

> **Optimize for confidence per test, not for the fewest tests.**

> **A test should earn its place by protecting meaningful behavior or a realistic failure mode.**

> **The current implementation is not necessarily the specification.**

> **A test that correctly exposes a meaningful production defect is valuable even when it currently fails.**

> **Code coverage is not test quality. A test that executes code but would pass while that code is meaningfully broken is not valuable coverage.**
