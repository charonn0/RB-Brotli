#tag Module
Private Module Decode
	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderCreateInstance Lib "libbrotlidec" (AllocFunction As Ptr, FreeFunction As Ptr, Opaque As Ptr) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderDecompress Lib "libbrotlidec" (EncodedSize As UInt32, EncodedBuffer As Ptr, ByRef DecodedSize As UInt32, DecodedBuffer As Ptr) As DecodeResult
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderDecompressStream Lib "libbrotlidec" (State As Ptr, ByRef AvailIn As UInt32, ByRef NextIn As Ptr, ByRef AvailOut As UInt32, ByRef NextOut As Ptr, ByRef TotalOut As UInt32) As DecodeResult
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Sub BrotliDecoderDestroyInstance Lib "libbrotlidec" (State As Ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderErrorString Lib "libbrotlidec" (ErrorCode As Integer) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderGetErrorCode Lib "libbrotlidec" (State As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderHasMoreOutput Lib "libbrotlidec" (State As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliDecoderVersion Lib "libbrotlidec" () As UInt32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function FormatError(ErrorCode As Integer) As String
		  If Not Brotli.IsAvailable Then Return "Brotli is not available"
		  Dim mb As MemoryBlock = BrotliDecoderErrorString(ErrorCode)
		  If mb <> Nil Then Return mb.CString(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Version() As UInt32
		  If Brotli.IsAvailable Then Return BrotliDecoderVersion()
		End Function
	#tag EndMethod


	#tag Enum, Name = DecodeResult, Type = Integer, Flags = &h1
		Error
		  Success
		  MoreInputNeeded
		MoreOutputNeeded
	#tag EndEnum


	#tag ViewBehavior
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
End Module
#tag EndModule
