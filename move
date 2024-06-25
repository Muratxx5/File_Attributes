Option Explicit

' Main entry point of the macro
Sub Main()
    ' Path to the text file
    Dim filePath As String
    filePath = "D:\MoveMacroTest\S01344\S01344ZY_KALIPHANE_3_NOKTA.txt"

    ' Read the file content
    Dim fileContent As String
    fileContent = ReadFile(filePath)

    ' Parse the file content into rows and columns
    Dim parsedContent As String
    parsedContent = ParseFileContent(fileContent)

    ' Show the parsed content in the Info window
    ShowInfo(parsedContent)
End Sub

' Function to read the file content
Function ReadFile(filePath As String) As String
    Dim fileSystem, file, fileContent
    Set fileSystem = CreateObject("Scripting.FileSystemObject")
    Set file = fileSystem.OpenTextFile(filePath, 1)
    fileContent = file.ReadAll
    file.Close
    ReadFile = fileContent
End Function

' Function to parse the file content into rows and columns
Function ParseFileContent(fileContent As String) As String
    Dim lines, line, i
    lines = Split(fileContent, vbCrLf)
    ParseFileContent = ""
    For i = LBound(lines) To UBound(lines)
        line = Replace(lines(i), " ", vbTab)
        ParseFileContent = ParseFileContent & line & vbCrLf
    Next
End Function

' Function to show the parsed content in the Info window
Sub ShowInfo(content As String)
    Dim theSession As NXOpen.Session = NXOpen.Session.GetSession()
    theSession.ListingWindow.Open()
    theSession.ListingWindow.WriteLine(content)
End Sub

' Execute the main subroutine
Main()