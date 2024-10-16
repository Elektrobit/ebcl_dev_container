*** Settings ***
Library    lib/Setup.py
Library    lib/Elbe.py
Suite Setup        Setup
Suite Teardown    Teardown
Keyword Tags    elbe

*** Test Cases ***

SDK shall provide elbe
    [Tags]    fast
    Elbe Is Available

*** Keywords ***
Setup
    Run Container

Teardown
    Stop Container
