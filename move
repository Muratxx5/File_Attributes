'NXJournaling.com
'example: read text file
'each line of the input file should be 3 numbers separated by commas (#.###, #.###, #.###)
'the numbers will be interpreted as line start/end points

Option Strict Off  
Imports System  
Imports System.IO  
Imports System.Windows.Forms  
Imports NXOpen  
Imports NXOpen.UF  

Module Module1  
	Dim ufs As UFSession = UFSession.GetUFSession  

	Sub Main()  
		Dim openFileDialog1 As New OpenFileDialog()  

		openFileDialog1.Filter = "txt files (*.txt)|*.txt|All files (*.*)|*.*"  
		openFileDialog1.FilterIndex = 1  
		openFileDialog1.RestoreDirectory = True  

		If openFileDialog1.ShowDialog() = DialogResult.OK Then  
			Dim theSession As Session = Session.GetSession()  
			Dim workPart As Part = theSession.Parts.Work  
			Dim line As String  
			Dim startPoint As Point3d  = nothing  
			Dim endPoint As Point3d  
			Dim i As Integer = 0  
			Dim firstPass as Boolean = True
			Dim delim As Char() = {","c}  
			Dim USculture As system.globalization.CultureInfo = New System.Globalization.CultureInfo("en-US")  
			
			Using sr As StreamReader = New StreamReader(openFileDialog1.FileName)  
			Try  
				line = sr.ReadLine()  
				While Not line Is Nothing  
					Dim strings As String() = line.Split(delim)  
					endPoint.x = Double.Parse(strings(0), USculture)  
					endPoint.y = Double.Parse(strings(1), USCulture)  
					endPoint.z = Double.Parse(strings(2), USCulture)  
					endPoint = Abs2WCS(endPoint)  
					If firstPass Then  
						firstPass = False  
					Else  
						'create a line from startpoint to endpoint
						workPart.Curves.CreateLine(startPoint, endPoint)  
					End If  
					startPoint = endPoint  
					line = sr.ReadLine()  
				End While  
			Catch E As Exception  
				MessageBox.Show(E.Message)  
			End Try
			End Using
		End If  
	
	End Sub  
'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
'Date:  11/18/2010
'Subject:  Sample NX Open .NET Visual Basic routine : map point from absolute to wcs
'
'Note:  function taken from GTAC example code

	Function Abs2WCS(ByVal inPt As Point3d) As Point3d  
		Dim pt1(2), pt2(2) As Double  

		pt1(0) = inPt.X  
		pt1(1) = inPt.Y  
		pt1(2) = inPt.Z  

		ufs.Csys.MapPoint(UFConstants.UF_CSYS_ROOT_COORDS, pt1, _  
			UFConstants.UF_CSYS_ROOT_WCS_COORDS, pt2)  

		Abs2WCS.X = pt2(0)  
		Abs2WCS.Y = pt2(1)  
		Abs2WCS.Z = pt2(2)  

    End Function   
'&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
	Public Function GetUnloadOption(ByVal dummy As String) As Integer  

'Unloads the image when the NX session terminates
		GetUnloadOption = NXOpen.Session.LibraryUnloadOption.AtTermination  

	End Function  

End Module 
