#!/bin/bash
set -euo pipefail

run_with_delay() {
  echo "🔧 Running fix: $1"
  eval "$1"
  sleep 0.5
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

# --- Efisiensi & performa ---
run_with_delay "fvm dart fix --apply --code=duplicate_import"
run_with_delay "fvm dart fix --apply --code=unused_import"
run_with_delay "fvm dart fix --apply --code=unused_local_variable"
run_with_delay "fvm dart fix --apply --code=unnecessary_import"
run_with_delay "fvm dart fix --apply --code=unnecessary_const"
run_with_delay "fvm dart fix --apply --code=unnecessary_late"
run_with_delay "fvm dart fix --apply --code=unnecessary_string_interpolations"
run_with_delay "fvm dart fix --apply --code=unnecessary_non_null_assertion"
run_with_delay "fvm dart fix --apply --code=sized_box_for_whitespace"
run_with_delay "fvm dart fix --apply --code=prefer_final_in_for_each"
run_with_delay "fvm dart fix --apply --code=prefer_const_constructors"
run_with_delay "fvm dart fix --apply --code=prefer_const_constructors_in_immutables"
run_with_delay "fvm dart fix --apply --code=prefer_const_literals_to_create_immutables"
run_with_delay "fvm dart fix --apply --code=prefer_const_declarations"
run_with_delay "fvm dart fix --apply --code=avoid_unnecessary_containers"
run_with_delay "fvm dart fix --apply --code=avoid_redundant_argument_values"
run_with_delay "fvm dart fix --apply --code=prefer_final_locals"
run_with_delay "fvm dart fix --apply --code=prefer_final_fields"
run_with_delay "fvm dart fix --apply --code=prefer_spread_collections"
run_with_delay "fvm dart fix --apply --code=prefer_collection_literals"
run_with_delay "fvm dart fix --apply --code=prefer_is_empty"
run_with_delay "fvm dart fix --apply --code=prefer_is_not_empty"
run_with_delay "fvm dart fix --apply --code=prefer_contains"
run_with_delay "fvm dart fix --apply --code=avoid_double_and_int_checks"
run_with_delay "fvm dart fix --apply --code=sort_constructors_first"
run_with_delay "fvm dart fix --apply --code=use_named_constants"
run_with_delay "fvm dart fix --apply --code=curly_braces_in_flow_control_structures"
run_with_delay "fvm dart fix --apply --code=prefer_relative_imports"
run_with_delay "fvm dart fix --apply --code=unnecessary_question_mark"
run_with_delay "fvm dart fix --apply --code=unused_catch_stack"

# --- Keamanan & bug prevention ---
run_with_delay "fvm dart fix --apply --code=hash_and_equals"
run_with_delay "fvm dart fix --apply --code=use_rethrow_when_possible"
run_with_delay "fvm dart fix --apply --code=throw_in_finally"
run_with_delay "fvm dart fix --apply --code=await_only_futures"
run_with_delay "fvm dart fix --apply --code=avoid_null_checks_in_equality_operators"
run_with_delay "fvm dart fix --apply --code=avoid_field_initializers_in_const_classes"

echo "✅ All automatic fixes applied successfully!"
