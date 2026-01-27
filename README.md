# INVARIANT-GUARD-FAMILY
# Invariant Guard Library

## Overview
This library provides invariant-based enforcement for:
- Balance
- Storage
- Transient Storage
- Contract Code

## Design Philosophy
- Invariants over inline requires
- Explicit delta rules
- Audit-first error reporting

## DeltaRule Model
- CONSTANT
- INCREASE_EXACT / DECREASE_EXACT
- INCREASE_MAX / DECREASE_MAX
- INCREASE_MIN / DECREASE_MIN

## Storage vs Transient Storage
- `storage` uses native Solidity storage references
- `transient storage` is currently modeled via memory arrays
- Design anticipates future EOF / transient keywords

## Modifier Usage Guidelines
- Recommended modifier order
- Invalid combinations
- Examples

## Gas & Performance Notes
- Array-based validation
- Error accumulation strategy
- Future optimization paths

## Security Considerations
- Reentrancy model assumptions
- Callback safety
- Interaction with selfdestruct / code changes 
