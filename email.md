
Purview

Message Trace:
https://admin.exchange.microsoft.com/


John and Andrew shared their hypothesis with us. 

### AVD Environment
Finance users have access to an AVD environment which includes access to tools such as Excel. 
![[2025-07-15 15_53_38-2025-07-15 15_34_00-Email investigation - Catch-up Call _ Trustwave Holdings, In.png]]



2) In Excel there is an add-on named CCH Tagetik. A finance based tool which the finance team use for their work. 
![[Pasted image 20250715160740.png]]





3) When the user wishes to share the workbook, they go to **File->Share->Workbook**. This is something we did try ourselves but in our Aggreko environment we don't have the same interfaces or processes.
![[Pasted image 20250715160827.png]]




4) Clicking Excel Workbook opens up the Outlook application **but inside the AVD cloud system** which is a different instance from their local outlook. The two should sync but are running in parrellel. The user can enter in the recipient details, CC, BCC and the body. Their signature is added by default, and the email subject is automatically set to the name of the file (e.g. "North Recoveries.xlsx")

5) When they send the email, it goes into the Outbox as standard in order to send. However, if the user closes their cloud environment quickly, the email gets stuck in the outbox and Microsoft doesn't sync and "push" this email through to delivery.
![[Pasted image 20250715161137.png]]

![[Pasted image 20250715161155.png]]


6) The user believes the email has sent. In the case of Tomas, the email from March that he thought he sent, was actually stuck in the Outbox. It sent recently due to him logging back in and the sync taking place. This caused his colleague to ask him *why did you just send me an email from March?*

