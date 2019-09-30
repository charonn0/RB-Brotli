#tag Module
Private Module Encode
	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliEncoderCompress Lib "libbrotlienc" (Quality As Int32, lgWin As Int32, Mode As EncoderMode, InputSize As UInt32, InputBuffer As Ptr, ByRef EncodedSize As UInt64, EncodedBuffer As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliEncoderCompressStream Lib "libbrotlienc" (State As Ptr, Operation As Operation, ByRef AvailIn As UInt32, ByRef NextIn As Ptr, ByRef AvailOut As UInt32, ByRef NextOut As Ptr, ByRef TotalOut As UInt32) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Function BrotliEncoderCreateInstance Lib "libbrotlienc" (AllocFunction As Ptr, FreeFunction As Ptr, Opaque As Ptr) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h1
		Protected Soft Declare Sub BrotliEncoderDestroyInstance Lib "libbrotlienc" (State As Ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderVersion Lib "libbrotlienc" () As UInt32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function Version() As UInt32
		  If Brotli.IsAvailable Then Return BrotliEncoderVersion()
		End Function
	#tag EndMethod


	#tag Enum, Name = EncoderMode, Type = Integer, Flags = &h1
		Generic
		  Text
		  Font
		Default=EncoderMode.Generic
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
