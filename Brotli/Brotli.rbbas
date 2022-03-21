#tag Module
Protected Module Brotli
	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderCreateInstance Lib libbrotlidec (AllocFunction As Ptr, FreeFunction As Ptr, Opaque As Ptr) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderDecompress Lib libbrotlidec (EncodedSize As UInt32, EncodedBuffer As Ptr, ByRef DecodedSize As UInt32, DecodedBuffer As Ptr) As DecodeResult
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderDecompress64 Lib libbrotlidec Alias "BrotliDecoderDecompress" (EncodedSize As UInt64, EncodedBuffer As Ptr, ByRef DecodedSize As UInt64, DecodedBuffer As Ptr) As DecodeResult
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderDecompressStream Lib libbrotlidec (State As Ptr, ByRef AvailIn As UInt32, ByRef NextIn As Ptr, ByRef AvailOut As UInt32, ByRef NextOut As Ptr, ByRef TotalOut As UInt32) As DecodeResult
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderDecompressStream64 Lib libbrotlidec Alias "BrotliDecoderDecompressStream" (State As Ptr, ByRef AvailIn As UInt64, ByRef NextIn As Ptr, ByRef AvailOut As UInt64, ByRef NextOut As Ptr, ByRef TotalOut As UInt64) As DecodeResult
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub BrotliDecoderDestroyInstance Lib libbrotlidec (State As Ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderErrorString Lib libbrotlidec (ErrorCode As Integer) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderGetErrorCode Lib libbrotlidec (State As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderHasMoreOutput Lib libbrotlidec (State As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderIsFinished Lib libbrotlidec (State As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderIsUsed Lib libbrotlidec (State As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderSetParameter Lib libbrotlidec (State As Ptr, Param As CodecOption, Value As UInt32) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderSetParameter64 Lib libbrotlidec Alias "BrotliDecoderSetParameter" (State As Ptr, Param As CodecOption, Value As UInt64) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliDecoderVersion Lib libbrotlidec () As UInt32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderCompress Lib libbrotlienc (Quality As Int32, lgWin As Int32, Mode As EncoderMode, InputSize As UInt32, InputBuffer As Ptr, ByRef EncodedSize As UInt32, EncodedBuffer As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderCompress64 Lib libbrotlienc Alias "BrotliEncoderCompress" (Quality As Int32, lgWin As Int32, Mode As EncoderMode, InputSize As UInt64, InputBuffer As Ptr, ByRef EncodedSize As UInt64, EncodedBuffer As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderCompressStream Lib libbrotlienc (State As Ptr, Operation As Operation, ByRef AvailIn As UInt32, ByRef NextIn As Ptr, ByRef AvailOut As UInt32, ByRef NextOut As Ptr, ByRef TotalOut As UInt32) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderCompressStream64 Lib libbrotlienc Alias "BrotliEncoderCompressStream" (State As Ptr, Operation As Operation, ByRef AvailIn As UInt64, ByRef NextIn As Ptr, ByRef AvailOut As UInt64, ByRef NextOut As Ptr, ByRef TotalOut As UInt64) As Int32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderCreateInstance Lib libbrotlienc (AllocFunction As Ptr, FreeFunction As Ptr, Opaque As Ptr) As Ptr
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Sub BrotliEncoderDestroyInstance Lib libbrotlienc (State As Ptr)
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderGetErrorCode Lib libbrotlienc (State As Ptr) As Integer
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderHasMoreOutput Lib libbrotlienc (State As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderIsFinished Lib libbrotlienc (State As Ptr) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderMaxCompressedSize Lib libbrotlienc (InputSize As UInt32) As UInt32
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderMaxCompressedSize64 Lib libbrotlienc (InputSize As UInt64) As UInt64
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderSetParameter Lib libbrotlienc (State As Ptr, Option As CodecOption, Value As UInt32) As Boolean
	#tag EndExternalMethod

	#tag ExternalMethod, Flags = &h21
		Private Soft Declare Function BrotliEncoderVersion Lib libbrotlienc () As UInt32
	#tag EndExternalMethod

	#tag Method, Flags = &h1
		Protected Function CompressBound(DataLength As UInt64) As UInt64
		  ' Computes the upper bound of the compressed size after compressing DataLength bytes. This 
		  ' allows you to determine the maximum number of bytes that the algorithm might produce in a
		  ' worst-case scenario.
		  
		  If Not Brotli.IsAvailable Then Return 0
		  #If Target32Bit Then
		    Return BrotliEncoderMaxCompressedSize(DataLength)
		  #Else
		    Return BrotliEncoderMaxCompressedSize64(DataLength)
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Decode(Buffer As MemoryBlock, Optional DecodedSize As UInt64) As MemoryBlock
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  If DecodedSize = 0 Then DecodedSize = Buffer.Size * 3
		  Dim output As New MemoryBlock(DecodedSize)
		  #If Target32Bit Then
		    Dim outsz As UInt32 = output.Size
		    Do Until BrotliDecoderDecompress(Buffer.Size, Buffer, outsz, output) = DecodeResult.Success
		  #Else
		    Dim outsz As UInt64 = output.Size
		    Do Until BrotliDecoderDecompress64(Buffer.Size, Buffer, outsz, output) = DecodeResult.Success
		  #EndIf
		  output.Size = output.Size * 1.5
		  outsz = output.Size
		  Loop
		  output.Size = outsz
		  Return output
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Encode(Buffer As MemoryBlock, Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY, Mode As Brotli.EncoderMode = Brotli.EncoderMode.Default) As MemoryBlock
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  Dim output As New MemoryBlock(Buffer.Size)
		  #If Target32Bit Then
		    Dim outsz As UInt32 = output.Size
		    Do Until BrotliEncoderCompress(Quality, BROTLI_DEFAULT_WINDOW, Mode, Buffer.Size, Buffer, outsz, output)
		  #Else
		    Dim outsz As UInt64 = output.Size
		    Do Until BrotliEncoderCompress64(Quality, BROTLI_DEFAULT_WINDOW, Mode, Buffer.Size, Buffer, outsz, output)
		  #EndIf
		  If output.Size > Buffer.Size * 15 Then Return Nil
		  output.Size = output.Size * 1.5
		  Loop
		  output.Size = outsz
		  Return output
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If Brotli.IsAvailable Then Return BrotliDecoderVersion()
			End Get
		#tag EndGetter
		Protected DecoderVersion As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  If Brotli.IsAvailable Then Return BrotliEncoderVersion()
			End Get
		#tag EndGetter
		Protected EncoderVersion As UInt32
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  ' Returns True if Brotli is available.
			  
			  Static available As Boolean = IsDecoderAvailable Or IsEncoderAvailable
			  Return available
			End Get
		#tag EndGetter
		Protected IsAvailable As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  ' Returns True if decompression is available.
			  
			  Static available As Boolean = System.IsFunctionAvailable("BrotliDecoderCreateInstance", libbrotlidec)
			  Return available
			End Get
		#tag EndGetter
		Protected IsDecoderAvailable As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h1
		#tag Getter
			Get
			  ' Returns True if compression is available.
			  
			  Static available As Boolean = System.IsFunctionAvailable("BrotliEncoderCreateInstance", libbrotlienc)
			  Return available
			End Get
		#tag EndGetter
		Protected IsEncoderAvailable As Boolean
	#tag EndComputedProperty


	#tag Constant, Name = BROTLI_DEFAULT_QUALITY, Type = Double, Dynamic = False, Default = \"BROTLI_MAX_QUALITY", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BROTLI_DEFAULT_WINDOW, Type = Double, Dynamic = False, Default = \"22", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BROTLI_MAX_QUALITY, Type = Double, Dynamic = False, Default = \"11", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BROTLI_MIN_QUALITY, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = CHUNK_SIZE, Type = Double, Dynamic = False, Default = \"524288", Scope = Private
	#tag EndConstant

	#tag Constant, Name = libbrotlidec, Type = String, Dynamic = False, Default = \"libbrotlidec.so.1", Scope = Private
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"libbrotlidec.dll"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"libbrotlidec.so.1"
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"@executable_path/../Frameworks/libbrotlidec.1.dylib"
	#tag EndConstant

	#tag Constant, Name = libbrotlienc, Type = String, Dynamic = False, Default = \"libbrotlienc.so.1", Scope = Private
		#Tag Instance, Platform = Windows, Language = Default, Definition  = \"libbrotlienc.dll"
		#Tag Instance, Platform = Linux, Language = Default, Definition  = \"libbrotlienc.so.1"
		#Tag Instance, Platform = Mac OS, Language = Default, Definition  = \"@executable_path/../Frameworks/libbrotlienc.1.dylib"
	#tag EndConstant


	#tag Enum, Name = CodecOption, Flags = &h1
		Mode=0
		  Quality=1
		  LGWIN=2
		  LGBLOCK=3
		  DisableLiteralContextModeling=4
		  SizeHint=5
		DisableRingBufferRealloc=0
	#tag EndEnum

	#tag Enum, Name = DecodeResult, Flags = &h1
		Error
		  Success
		  MoreInputNeeded
		MoreOutputNeeded
	#tag EndEnum

	#tag Enum, Name = EncoderMode, Flags = &h1
		Generic
		  Text
		  Font
		Default=EncoderMode.Generic
	#tag EndEnum

	#tag Enum, Name = Operation, Flags = &h1
		Process
		  Flush
		  Finish
		EmitMetaData
	#tag EndEnum


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
