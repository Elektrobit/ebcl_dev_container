*** Settings ***
Library    lib/Setup.py
Library    lib/Rust.py
Suite Setup        Setup
Suite Teardown    Teardown
Keyword Tags    rust

*** Test Cases ***

SDK shall provide rustc
    [Tags]    fast
    Skip    rust support removed
    Rustc Is Available

SDK shall provide cargo
    [Tags]    fast
    Skip    rust support removed
    Cargo Is Available

*** Keywords ***
Setup
    Run Container

Teardown
    Stop Container
