#tag Class
Protected Class BrotliException
Inherits RuntimeException
	#tag Method, Flags = &h1000
		Sub Constructor(ErrantItem As Brotli.Codec)
		  If ErrantItem IsA Decoder Then
		    Me.ErrorNumber = GetDecoderError(ErrantItem)
		    Me.Message = FormatDecoderError(Me.ErrorNumber)
		  Else
		    Me.Message = "Error while encoding Brotli"
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function FormatDecoderError(ErrorCode As Integer) As String
		  If Not Brotli.IsAvailable Then Return "Brotli is not available"
		  Dim mb As MemoryBlock = BrotliDecoderErrorString(ErrorCode)
		  If mb <> Nil Then Return mb.CString(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Shared Function GetDecoderError(ErrantItem As Codec) As Integer
		  If ErrantItem <> Nil And ErrantItem.Handle <> Nil Then Return BrotliDecoderGetErrorCode(ErrantItem.Handle)
		End Function
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			InheritedFrom="RuntimeException"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Message"
			Group="Behavior"
			Type="String"
			EditorType="MultiLineEditor"
			InheritedFrom="RuntimeException"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InheritedFrom="Object"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			InheritedFrom="Object"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
