
Press Alt + F11 keys to open Microsoft Visual Basic for Applications window  
Insert>Module  
Copy code below and press F5  
Select folder containing the CSV files  

```VBA
Sub ExportSlidesToWordWithBordersUsingTemplate()
    Dim pptSlide As Slide
    Dim wordApp As Object
    Dim wordDoc As Object
    Dim slideImage As String
    Dim slideRange As Object
    Dim slideShape As Object

    ' Start Word and open the template
    Set wordApp = CreateObject("Word.Application")
    wordApp.Visible = True
    Set wordDoc = wordApp.Documents.Open("C:\Users\garyh\Documents\@CLIENTS\@DOCS\ttx_template.docx")

    ' Loop through each slide in the PowerPoint presentation
    For Each pptSlide In ActivePresentation.Slides
        ' Export each slide as an image file
        slideImage = Environ("Temp") & "\Slide" & pptSlide.SlideIndex & ".jpg"
        pptSlide.Export slideImage, "JPG"

        ' Set a range to the end of the document
        Set slideRange = wordDoc.Content
        slideRange.Collapse Direction:=0 ' Collapse to end of document

        ' Insert the slide image
        Set slideShape = slideRange.InlineShapes.AddPicture(slideImage)

        ' Add a 1.5pt black border to the image
        With slideShape.Line
            .Visible = True
            .ForeColor.RGB = RGB(0, 0, 0) ' Black colour
            .Weight = 1.5 ' 1.5pt border
        End With

        ' Add a page break after each slide to start the next slide on a new page
        slideRange.Collapse Direction:=0
        slideRange.InsertBreak Type:=7 ' wdPageBreak

        ' Delete the temporary image file after insertion
        Kill slideImage
    Next pptSlide

    ' Save the document with a new name to avoid overwriting the template
    wordDoc.SaveAs2 "C:\Users\garyh\Documents\@CLIENTS\new_ttx_report.docx"
    wordApp.Quit

    MsgBox "Slides exported to Word template with borders successfully, each slide on a new page."
End Sub

```

