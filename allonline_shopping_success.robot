*** Settings ***
Library    SeleniumLibrary
Suite Setup    เปิดเบราว์เซอร์    ${URL}    ${BROWSER}
Suite Teardown     Close All Browsers
*** Variables ***
${URL}    https://www.allonline.7eleven.co.th/
${BROWSER}    chrome
${USER}    example@hotmail.co.th
${PASSWORD}    password
${NAME}    พิทยา แสงทอง
${TEL}    0956871234
${ADDRESS_DETAIL}    เซเว่นอีเลฟเว่น #10520    

*** Test Cases ***
ทดสอบซื้อสินค้าบนเว็บไซต์ All Online สำเร็จ
    เข้าสู่ระบบ    ${USER}    ${PASSWORD}

    ลบสินค้าในตะกร้า

    ค้นหาสินค้า เลือกสินค้น ตรวจสอบและเพิ่มลงตะกร้า    
    ...    เนสกาแฟ    เนสกาแฟ เรดคัพ ถุง 40 กรัม    
    ...    //*[contains(@title,'เนสกาแฟ เรดคัพ ถุง 40 กรัม')][1]    
    ...    เนสกาแฟ เรดคัพ ถุง 40 กรัม      ฿ 66   คุณจะได้รับ 18 คะแนน

    ค้นหาสินค้า เลือกสินค้น ตรวจสอบและเพิ่มลงตะกร้า    
    ...    โฟร์โมสต์    โฟร์โมสต์ นมยูเอชที รสจืด 1 ลิตร    
    ...    //*[contains(@title,'โฟร์โมสต์ นมยูเอชที รสจืด 1 ลิตร')][1]   
    ...    โฟร์โมสต์ นมยูเอชที รสจืด 1 ลิตร      ฿ 46   คุณจะได้รับ 12 คะแนน

    กดปุ่มชำระค่าสินค้า
    เลือกวิธีการจัดส่ง
    เลือกวิธีการชำระเงินแบบเงินสด    
    ตรวจสอบรายการสั่งซื้อ    ฿ 112    33    ${NAME}    ${TEL}    ${ADDRESS_DETAIL}  

    ปิดเบราว์เซอร์


*** Keywords ***
ค้นหาสินค้า เลือกสินค้น ตรวจสอบและเพิ่มลงตะกร้า
    [Arguments]    ${Search_Query}    ${Excepted_Query}    ${Position}    ${ProductName}    ${ProductPrice}    ${ProductPoint}
    ใส่คำค้นและตรวจสอบผล    ${Search_Query}    ${Excepted_Query}    
    เลือกสินค้า    ${Position}
    ตรวจสอบชื่อสินค้า ราคาและแต้ม    ${ProductName}    ${ProductPrice}    ${ProductPoint}
    เพิ่มลงตะกร้า

เปิดเบราว์เซอร์
    [Arguments]    ${URL}    ${BROWSER}
    Open Browser    url=${URL}    browser=${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    id=btn-accept-gdpr
    Click Element   id=btn-accept-gdpr

เข้าสู่ระบบ
    [Arguments]    ${USER}    ${PASSWORD}
    Click Link    //*[@id="page"]/header/div[4]/div/div/div/ul/li[4]/a
    Input Text    xpath=//input[@type='email' and @name='email']    text=${USER}
    Input Text    xpath=//input[@type='password' and @name='password']    text=${PASSWORD}
    Click Element  xpath=//a[@class='btn btn-small' and text()='เข้าสู่ระบบ']

ใส่คำค้นและตรวจสอบผล
    [Arguments]    ${SEARCH_QUERY}    ${SEARCH_RESULT}
    Wait Until Element Is Visible    name=q    30s
    Clear Element Text    name=q
    Input Text    name=q    ${SEARCH_QUERY}
    Click Element    class=input-group-btn
    Wait Until Element Is Visible    class=productlink
    Wait Until Page Contains    ${SEARCH_RESULT}    

เลือกสินค้า
    [Arguments]    ${LINK_PRODUCT}
    Scroll Element Into View  ${LINK_PRODUCT}
    Click Element    ${LINK_PRODUCT}  

ตรวจสอบชื่อสินค้า ราคาและแต้ม
    [Arguments]    ${ProductName}    ${Price}    ${Point}
    Wait Until Element Is Visible    id=title-product
    Element Should Contain    id=title-product    ${ProductName}
    Element Should Contain    class=currentPrice    ${Price}
    Element Should Contain    (//*[contains(text(),'คุณจะได้รับ')])[1]    ${Point}

เพิ่มลงตะกร้า
    Run Keyword And Ignore Error    Click Element   id=btn-accept-gdpr
    Wait Until Page Contains Element    (//*[@class="glyphicon glyphicon-icon-cart"])[2]    
    Scroll Element Into View    (//*[@class="glyphicon glyphicon-icon-cart"])[2]    
    Click Element   (//*[@class="glyphicon glyphicon-icon-cart"])[2]

กดปุ่มชำระค่าสินค้า
    Wait Until Element Is Visible    (//*[@class="glyphicon glyphicon-icon-cart"])[1]
    
    # กดที่ตะกร้าแล้วมี Modal แสดง
    ${MODALCLICK}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[text()='ชำระค่าสินค้า']    
    IF    ${MODALCLICK}
        Click Element    //*[text()='ชำระค่าสินค้า']
    END

    # กดที่ตะกร้าแล้วไม่มี Modal แสดง > แสดงเมนู Bucket แทน
    # สาเหตุ: เพราะมีการกดที่ตะกร้า 2 ครั้ง (Double click) ทำให้เว็บแสดงเมนู Bucket > แต่สั่งแค่ครั้งเดียว (Line 88)
    ${MENUCLICK}    Run Keyword And Return Status    Wait Until Element Is Visible    //*[text()="ดำเนินการชำระเงิน"]
    IF    ${MENUCLICK}
        Click Element    //*[text()="ดำเนินการชำระเงิน"]
    END

เลือกวิธีการจัดส่ง
    Input Text    id=second-phone-shipping    ${TEL}
    Click Element    //*[text()='ค้นหาผ่านรหัสร้าน เซเว่นอีเลฟเว่น ( 7-11 )']
    Wait Until Element Is Visible    id=user-storenumber-input
    Input Text    id=user-storenumber-input    10520
    Click Element    id=btn-check-storenumber
    Click Element    id=continue-payment-btn

เลือกวิธีการชำระเงินแบบเงินสด
    Wait Until Page Contains    วิธีการชำระเงิน
    Click Element    //*[contains(text(),'ชำระเงินสด ที่ร้านเซเว่นอีเลฟเว่น (7-11)')]

ตรวจสอบรายการสั่งซื้อ
    [Arguments]    ${TotalPrice}    ${TotalPoint}    ${UserName}    ${PhonNumber}    ${ADDRESS} 
    Element Should Contain    id=totalAmount    ${TotalPrice} 
    Element Should Contain    //*[@Class='font-normal font-Online']    ${TotalPoint}
    Element Should Contain    //*[@Class="invoice-address-wrapper"]/p    ${UserName}    
    Element Should Contain    //*[@Class="address"]    ${PhonNumber}        
    Element Should Contain    //*[@Class="address-7_11_store-detail-header"]    ${ADDRESS}     

กดปุ่มสั่งซื้อ
    Element Should Be Visible   (//*[@class="glyphicon glyphicon-icon-cart"])[1] 
    Click Element    (//*[@class="glyphicon glyphicon-icon-cart"])[1]  

ลบสินค้าในตะกร้า
    ${CART}    Run Keyword And Return Status    Wait Until Element Is Visible    class=cart-indicator    20s    
    IF   ${CART}
        ${PRODUCT_COUNT}    Get Text    class=cart-indicator
        IF    '${PRODUCT_COUNT}' != '${EMPTY}'
            Click Element   (//*[@class="glyphicon glyphicon-icon-cart"])[1]
            Wait Until Element Is Visible    //*[@class='remove']//i    
            ${COUNT}    Get Element Count    //*[@class='remove']//i

            WHILE    '${PRODUCT_COUNT}' != '${EMPTY}'
                ${TEMP}    Run Keyword And Return Status    Page Should Contain Element    mini-basket-val
                IF    not(${TEMP})
                    Click Element   (//*[@class="glyphicon glyphicon-icon-cart"])[1]
                END
                Click Element    (//*[@class='remove']//i)[1]
                Sleep    1.75s
                ${PRODUCT_COUNT}    Get Text    class=cart-indicator
            END
        END
    END

ปิดเบราว์เซอร์
    Sleep    15s
    Close Browser