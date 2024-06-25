Option Strict Off
Imports System
Imports System.IO
Imports NXOpen
Imports NXOpen.UI

Module Module1

    Sub Main()
        ' Get the current NX session
        Dim theSession As Session = Session.GetSession()

        ' Path to the text file
        Dim filePath As String = "D:\MoveMacroTest\S01344\S01344ZY_KALIPHANE_3_NOKTA.txt"

        ' Read the file content
        Dim fileContent As String = ReadFile(filePath)

        ' Parse the file content into rows and columns
        Dim parsedContent As String = ParseFileContent(fileContent)

        ' Show the parsed content in the Info window
        ShowInfo(parsedContent)
    End Sub

    ' Function to read the file content
    Function ReadFile(filePath As String) As String
        Dim fileContent As String = ""
        Try
            Using sr As New StreamReader(filePath)
                fileContent = sr.ReadToEnd()
            End Using
        Catch e As Exception
            UI.GetUI().NXMessageBox.Show("Error", NXMessageBox.DialogType.Error, "The file could not be read: " & e.Message)
        End Try
        Return fileContent
    End Function

    ' Function to parse the file content into rows and columns
    Function ParseFileContent(fileContent As String) As String
        Dim lines() As String = fileContent.Split(New String() {Environment.NewLine}, StringSplitOptions.None)
        Dim parsedContent As String = ""
        For Each line As String In lines
            Dim parsedLine As String = line.Replace(" ", vbTab)
            parsedContent &= parsedLine & Environment.NewLine
        Next
        Return parsedContent
    End Function

    ' Function to show the parsed content in the Info window
    Sub ShowInfo(content As String)
        Dim theSession As Session = Session.GetSession()
        theSession.ListingWindow.Open()
        theSession.ListingWindow.WriteLine(content)
    End Sub

    Public Function GetUnloadOption(ByVal arg As String) As Integer
        Return NXOpen.Session.LibraryUnloadOption.Immediately
    End Function

End Module