#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/.." || exit

run_with_delay() {
  echo "🔧 Running fix: $1"
  eval "$1"
  sleep 0.5
}

run_fix_code() {
  run_with_delay "fvm dart fix --apply --code=$1"
}

# =========================
# CAFFEINATE
# =========================
caffeinate -dimsu &
CAFFEINATE_PID=$!

cleanup() {
  echo "🧹 Cleaning up caffeinate..."
  kill -TERM "$CAFFEINATE_PID" 2>/dev/null || true
  wait "$CAFFEINATE_PID" 2>/dev/null || true
}

trap cleanup EXIT
trap 'exit 130' INT TERM

echo "🚀 Starting Dart code optimization..."

# These codes are aligned to linter rules in analysis_options.yaml.
LINT_FIX_CODES=(
  unnecessary_const
  unnecessary_late
  unnecessary_string_interpolations
  sized_box_for_whitespace
  prefer_final_in_for_each
  prefer_const_constructors
  prefer_const_constructors_in_immutables
  prefer_const_literals_to_create_immutables
  prefer_const_declarations
  avoid_unnecessary_containers
  avoid_redundant_argument_values
  prefer_final_locals
  prefer_final_fields
  prefer_spread_collections
  prefer_collection_literals
  prefer_is_empty
  prefer_is_not_empty
  prefer_contains
  avoid_double_and_int_checks
  use_colored_box
  use_decorated_box
  use_string_buffers
  sort_constructors_first
  use_named_constants
  curly_braces_in_flow_control_structures
  prefer_relative_imports
  require_trailing_commas
  hash_and_equals
  use_rethrow_when_possible
  throw_in_finally
  await_only_futures
  avoid_null_checks_in_equality_operators
  avoid_field_initializers_in_const_classes
)

# These are analyzer diagnostics (not linter rules) but still worth auto-fixing.
DIAGNOSTIC_FIX_CODES=(
  duplicate_import
  unused_import
  unused_local_variable
  unnecessary_import
  unnecessary_non_null_assertion
  unnecessary_question_mark
  unused_catch_stack
)

for code in "${LINT_FIX_CODES[@]}"; do
  run_fix_code "$code"
done

for code in "${DIAGNOSTIC_FIX_CODES[@]}"; do
  run_fix_code "$code"
done

run_with_delay "fvm dart format ."
run_with_delay "fvm dart analyze"

echo "✅ Automatic fixes + analyzer validation completed successfully!"
