```
# Set our path of source CSV files and our destination file
$csvFiles = Get-ChildItem "C:\Users\garyh\Downloads\myfiles\" -Filter *.csv
$outputFile = "C:\Users\garyh\Downloads\myfiles\combined.csv"
 
# Set a flag to check if it's the first file so we can prevent multiple header lines
$firstCSV = $true
 
# Loop through each CSV file
foreach ($file in $csvFiles) {
    # Read the contents of the current CSV file
    $content = Get-Content $file.FullName | Select-Object -Skip 1
     
    # If it's the first CSV file, include the header
    if ($firstCSV) {
        $header = Get-Content $file.FullName | Select-Object -First 1
        $header | Out-File $outputFile
        $firstCSV = $false
    }
     
    # Append the CSV to our new combined destination file
    $content | Out-File $outputFile -Append
}
```
