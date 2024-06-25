Option Strict Off
Imports System
Imports System.IO
Imports System.Windows.Forms
Imports NXOpen
Imports NXOpen.UF

Module Module1
    Dim ufs As UFSession = UFSession.GetUFSession()

    Sub Main()
        Dim openFileDialog1 As New OpenFileDialog()

        openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*"
        openFileDialog1.FilterIndex = 1
        openFileDialog1.RestoreDirectory = True

        If openFileDialog1.ShowDialog() = DialogResult.OK Then
            Dim theSession As Session = Session.GetSession()
            Dim workPart As Part = theSession.Parts.Work
            Dim line As String
            Dim startPoint As Point3d = Nothing
            Dim endPoint As Point3d
            Dim firstPass As Boolean = True
            Dim delim As Char() = {" "c}
            Dim USculture As System.Globalization.CultureInfo = New System.Globalization.CultureInfo("en-US")

            ' Open the listing window
            theSession.ListingWindow.Open()

            Using sr As StreamReader = New StreamReader(openFileDialog1.FileName)
                Try
                    line = sr.ReadLine()
                    While Not line Is Nothing
                        Dim strings As String() = line.Split(delim, StringSplitOptions.RemoveEmptyEntries)
                        If strings.Length >= 5 Then
                            endPoint.X = Double.Parse(strings(2), USculture)
                            endPoint.Y = Double.Parse(strings(3), USculture)
                            endPoint.Z = Double.Parse(strings(4), USculture)
                            endPoint = Abs2WCS(endPoint)

                            ' Display the point in the listing window
                            theSession.ListingWindow.WriteLine("Point: X=" & endPoint.X & ", Y=" & endPoint.Y & ", Z=" & endPoint.Z)

                            If firstPass Then
                                firstPass = False
                            Else
                                ' Create a line from startPoint to endPoint
                                workPart.Curves.CreateLine(startPoint, endPoint)
                            End If

                            startPoint = endPoint
                        End If
                        line = sr.ReadLine()
                    End While
                Catch e As Exception
                    MessageBox.Show(e.Message)
                End Try
            End Using

            ' Close the listing window
            theSession.ListingWindow.Close()
        End If
    End Sub

    ' Function to map point from absolute coordinates to WCS
    Function Abs2WCS(ByVal inPt As Point3d) As Point3d
        Dim pt1(2), pt2(2) As Double

        pt1(0) = inPt.X
        pt1(1) = inPt.Y
        pt1(2) = inPt.Z

        ufs.Csys.MapPoint(UFConstants.UF_CSYS_ROOT_COORDS, pt1, UFConstants.UF_CSYS_ROOT_WCS_COORDS, pt2)

        Abs2WCS.X = pt2(0)
        Abs2WCS.Y = pt2(1)
        Abs2WCS.Z = pt2(2)
    End Function

    ' Function to specify unload option
    Public Function GetUnloadOption(ByVal dummy As String) As Integer
        ' Unloads the image when the NX session terminates
        Return NXOpen.Session.LibraryUnloadOption.AtTermination
    End Function
End Module