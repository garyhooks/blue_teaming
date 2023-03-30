1. Close all workbooks
2. Open a new workbook
3. Press Alt + F11 keys to open Microsoft Visual Basic for Applications window
4. Insert>Module
5. Copy code below and press F5
6. Select folder containing the CSV files

```
Sub CSVtoXLS()
'UpdatebyExtendoffice20170814
    Dim xFd As FileDialog
    Dim xSPath As String
    Dim xCSVFile As String
    Dim xWsheet As String
    Application.DisplayAlerts = False
    Application.StatusBar = True
    xWsheet = ActiveWorkbook.Name
    Set xFd = Application.FileDialog(msoFileDialogFolderPicker)
    xFd.Title = "Select a folder:"
    If xFd.Show = -1 Then
        xSPath = xFd.SelectedItems(1)
    Else
        Exit Sub
    End If
    If Right(xSPath, 1) <> "\" Then xSPath = xSPath + "\"
    xCSVFile = Dir(xSPath & "*.csv")
    Do While xCSVFile <> ""
        Application.StatusBar = "Converting: " & xCSVFile
        Workbooks.Open Filename:=xSPath & xCSVFile
        ActiveWorkbook.SaveAs Replace(xSPath & xCSVFile, ".csv", ".xlsx", vbTextCompare), xlWorkbookDefault
        ActiveWorkbook.Close
        Windows(xWsheet).Activate
        xCSVFile = Dir
    Loop
    Application.StatusBar = False
    Application.DisplayAlerts = True
End Sub
```
