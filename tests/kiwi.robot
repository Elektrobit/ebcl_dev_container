*** Settings ***
Library    lib/Setup.py
Library    lib/Kiwi.py
Suite Setup        Setup
Suite Teardown    Teardown
Keyword Tags    kiwi

*** Test Cases ***

SDK shall provide Kiwi-ng and Berrymill
    [Tags]    fast
    Kiwi Is Available
    Berrymill Is Available

*** Keywords ***
Setup
    Run Container

Teardown
    Stop Container
