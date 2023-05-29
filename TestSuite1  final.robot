*** Settings ***
Library           SeleniumLibrary
Library           Collections
Library           BuiltIn

*** Variables ***
${username}       problem_user
${password}       secret_sauce
${mindate}        2010
${maxdate}        2020
${movie}          The Shawshank Redemption
${URL}            https://www.imdb.com/?ref_=nv_home

*** Test Cases ***
Scenario1
    Open Browser    ${URL}    gc
    Input Text    name=q    ${movie}
    Click Button    id:suggestion-search-button
    ${Titleslist}=    Get WebElement    class:ipc-metadata-list-summary-item__t
    ${title}=    get text    ${Titleslist}
    Should Be True    """${title}"""=="""${movie}"""

Scenario2
    Open Browser    ${URL}    gc
    Click Element    id:iconContext-menu
    click link    xpath://*[@id="imdbHeader"]/div[2]/aside/div/div[2]/div/div[1]/span/div/div/ul/a[2]
    ${Titleslist}=    Get WebElement    link:${movie}
    ${title}=    get text    ${Titleslist}
    Should Be True    """${title}"""=="""${movie}"""

Scenario3
    Open Browser    https://www.imdb.com/    gc
    click element    class:ipc-btn__text
    click element    id:iconContext-find-in-page
    click link    link:Advanced Title Search
    Select Checkbox    id:title_type-1
    Select Checkbox    id:genres-1
    input text    name:release_date-min    ${mindate}
    input text    name:release_date-max    ${maxdate}
    click button    class:primary
    click link    link:User Rating
    ${user_ratings}=    Get WebElements    name:ir
    ${org_list}    Create List
    FOR    ${item}    IN    @{user_ratings}
        ${filmrating}=    get text    ${item}
        ${filmrating}=    convert to number    ${filmrating}
        Append To List    ${org_list}    ${filmrating}
    END
    ${copy_list}=    Copy List    ${org_list}
    Sort List    ${copy_list}
    reverse List    ${copy_list}
    Lists Should Be Equal    ${copy_list}    ${org_list}
    ${releaseDates}=    Get WebElements    class:lister-item-year.text-muted.unbold
    ${dates_list}    Create List
    FOR    ${itemm}    IN    @{releaseDates}
        ${date}=    get text    ${itemm}
        ${date}=    convert to number    ${date.strip('(I) (')}
        Append To List    ${dates_list}    ${date}
    END
    ${copy}=    Copy List    ${dates_list}
    Sort List    ${copy}
    ${cnt}=    Get Length    ${copy}
    Should be True    ${copy}[0]>=${mindate}
    Should be True    ${copy}[0]<=${maxdate}
    ${lastelem}=    Evaluate    ${cnt}-1
    Should be True    ${copy}[${lastelem}]>=${mindate}
    Should be True    ${copy}[${lastelem}]<=${maxdate}
