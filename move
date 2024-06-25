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

        openFileDialog1.Filter = "csv files (*.csv)|*.csv|All files (*.*)|*.*"
        openFileDialog1.FilterIndex = 1
        openFileDialog1.RestoreDirectory = True

        If openFileDialog1.ShowDialog() = DialogResult.OK Then
            Dim theSession As Session = Session.GetSession()
            Dim workPart As Part = theSession.Parts.Work
            Dim line As String
            Dim startPoint As New Point3d(0, 0, 0)
            Dim endPoint As Point3d
            Dim firstPass As Boolean = True
            Dim delim As Char() = {ControlChars.Tab}
            Dim USculture As System.Globalization.CultureInfo = New System.Globalization.CultureInfo("en-US")

            ' Open the listing window
            theSession.ListingWindow.Open()

            ' Create UCS for the first three points
            Dim ucs1 As Matrix3x3 = CreateUCS(openFileDialog1.FileName, 0, 2, 3, 4)

            ' Create UCS for the next three points
            Dim ucs2 As Matrix3x3 = CreateUCS(openFileDialog1.FileName, 3, 5, 6, 7)

            Using sr As StreamReader = New StreamReader(openFileDialog1.FileName)
                Try
                    Dim count As Integer = 0
                    While Not sr.EndOfStream
                        line = sr.ReadLine()
                        Dim strings As String() = line.Split(delim, StringSplitOptions.RemoveEmptyEntries)
                        If strings.Length >= 5 Then
                            endPoint.X = Double.Parse(strings(2).Replace(",", "."), USculture)
                            endPoint.Y = Double.Parse(strings(3).Replace(",", "."), USculture)
                            endPoint.Z = Double.Parse(strings(4).Replace(",", "."), USculture)

                            ' Transform point to WCS using the appropriate UCS
                            If count < 3 Then
                                endPoint.TransformWithMatrix3x3(ucs1)
                            Else
                                endPoint.TransformWithMatrix3x3(ucs2)
                            End If

                            ' Display the point in the listing window
                            theSession.ListingWindow.WriteLine("Point: X=" & endPoint.X & ", Y=" & endPoint.Y & ", Z=" & endPoint.Z)

                            If Not firstPass Then
                                ' Create a line from startPoint to endPoint
                                workPart.Curves.CreateLine(startPoint, endPoint)
                            End If

                            startPoint = endPoint
                            firstPass = False
                            count += 1
                        End If
                    End While
                Catch e As Exception
                    MessageBox.Show(e.Message)
                End Try
            End Using

            ' Close the listing window
            theSession.ListingWindow.Close()
        End If
    End Sub

    ' Function to create UCS from points in the CSV file
    Function CreateUCS(ByVal fileName As String, ByVal startIndex As Integer, ByVal xIndex As Integer, ByVal yIndex As Integer, ByVal zIndex As Integer) As Matrix3x3
        Dim ucs As Matrix3x3 = Nothing
        Dim delim As Char() = {ControlChars.Tab}
        Dim USculture As System.Globalization.CultureInfo = New System.Globalization.CultureInfo("en-US")

        Using sr As StreamReader = New StreamReader(fileName)
            Try
                For i As Integer = 0 To startIndex
                    Dim line As String = sr.ReadLine()
                    If line Is Nothing Then
                        Throw New Exception("Not enough points in the CSV file.")
                    End If
                Next

                Dim x, y, z As Double
                Dim line1 As String = sr.ReadLine()
                Dim strings1 As String() = line1.Split(delim, StringSplitOptions.RemoveEmptyEntries)
                If strings1.Length >= 5 Then
                    x = Double.Parse(strings1(xIndex).Replace(",", "."), USculture)
                    y = Double.Parse(strings1(yIndex).Replace(",", "."), USculture)
                    z = Double.Parse(strings1(zIndex).Replace(",", "."), USculture)
                    ucs = CreateUCSFromPoint(x, y, z)
                End If
            Catch e As Exception
                MessageBox.Show(e.Message)
            End Try
        End Using

        Return ucs
    End Function

    ' Function to create UCS from a point
    Function CreateUCSFromPoint(ByVal x As Double, ByVal y As Double, ByVal z As Double) As Matrix3x3
        Dim wcs As Matrix3x3 = UFSession.GetUFSession.Matrix.Create
        Dim ucs As Matrix3x3 = UFSession.GetUFSession.Matrix.Create

        Dim origin(2) As Double
        origin(0) = x
        origin(1) = y
        origin(2) = z

        ufs.Csys.CreateMatrix(0, origin, wcs)
        ufs.Csys.CreateMatrix(1, origin, ucs)

        Return ucs
    End Function

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