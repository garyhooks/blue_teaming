1. Close all workbooks
2. Open a new workbook
3. Press Alt + F11 keys to open Microsoft Visual Basic for Applications window
4. Insert>Module
5. Copy code below and press F5
6. Select folder containing the CSV files

## Merge multiple CSVs into one Excel File 

Remember to add a backslash on target directory

```
Sub MergeCSV()
    'Author:    Jerry Beaucaire
    'Date:      8/16/2010
    'Summary:   Import all CSV files from a folder into separate sheets
    '           named for the CSV filenames
    'Update:    2/8/2013   Macro replaces existing sheets if they already exist in master workbook
    Dim fpath   As String
    Dim fCSV    As String
    Dim wbCSV   As Workbook
    Dim wbMST   As Workbook
    
    Set wbMST = ThisWorkbook
    'Dim fpath As Variant
    fpath = InputBox("Path to the folder where the CSV files are:" & vbNewLine & "(Include backslash in the end)")
    Application.ScreenUpdating = False  'speed up macro
    Application.DisplayAlerts = False   'no error messages, take default answers
    fCSV = Dir(fpath & "*.csv")         'start the CSV file listing
    
        On Error Resume Next
        Do While Len(fCSV) > 0
            Set wbCSV = Workbooks.Open(fpath & fCSV)                    'open a CSV file
            wbMST.Sheets(ActiveSheet.Name).Delete                       'delete sheet if it exists
            ActiveSheet.Move After:=wbMST.Sheets(wbMST.Sheets.Count)    'move new sheet into Mstr
            Columns.AutoFit             'clean up display
            Selection.AutoFilter
            fCSV = Dir                  'ready next CSV
        Loop
      
    Application.ScreenUpdating = True
    Set wbCSV = Nothing
       
End Sub
```

## Convert CSVs in one directory into xlsx files

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
