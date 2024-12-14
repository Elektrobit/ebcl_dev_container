*** Settings ***
Library    lib/Base.py
Library    lib/Setup.py
Suite Setup        Setup
Suite Teardown    Teardown
Keyword Tags    base

*** Test Cases ***

SDK version shall match the container version
    [Tags]    fast
    Sdk Version    v1.4.7

SDK user shall be ebcl
    [Tags]    fast
    Ensure Ebcl User Is Used

SDK shall provide a proper Debian environment
    [Tags]    fast
    Ensure Environment Is Ok

*** Keywords ***
Setup
    Run Container

Teardown
    Stop Container
