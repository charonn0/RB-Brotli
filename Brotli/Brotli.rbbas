#tag Module
Protected Module Brotli
	#tag Method, Flags = &h1
		Protected Function Decode(Buffer As MemoryBlock) As MemoryBlock
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  Dim output As New MemoryBlock(Buffer.Size * 3)
		  Dim outsz As UInt32 = output.Size
		  Do Until Brotli.Decode.BrotliDecoderDecompress(Buffer.Size, Buffer, outsz, output) = Brotli.Decode.DecodeResult.Success
		    If output.Size > Buffer.Size * 15 Then Return Nil
		    output.Size = output.Size * 1.5
		  Loop
		  output.Size = outsz
		  Return output
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Encode(Buffer As MemoryBlock, Quality As Int32 = Brotli.BROTLI_DEFAULT_QUALITY, Mode As Brotli.Encode.EncoderMode = Brotli.Encode.EncoderMode.Default) As MemoryBlock
		  If Not Brotli.IsAvailable Then Raise New PlatformNotSupportedException
		  Dim output As New MemoryBlock(Buffer.Size)
		  Dim outsz As UInt64 = output.Size
		  Do Until Brotli.Encode.BrotliEncoderCompress(Quality, BROTLI_DEFAULT_WINDOW, Mode, Buffer.Size, Buffer, outsz, output)
		    If output.Size > Buffer.Size * 15 Then Return Nil
		    output.Size = output.Size * 1.5
		  Loop
		  output.Size = outsz
		  Return output
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAvailable() As Boolean
		  ' Returns True if Brotli is available.
		  
		  Static available As Boolean = System.IsFunctionAvailable("BrotliDecoderCreateInstance", libbrotlidec)
		  Return available
		End Function
	#tag EndMethod


	#tag Constant, Name = BROTLI_DEFAULT_QUALITY, Type = Double, Dynamic = False, Default = \"11", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = BROTLI_DEFAULT_WINDOW, Type = Double, Dynamic = False, Default = \"22", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = libbrotlidec, Type = String, Dynamic = False, Default = \"libbrotlidec", Scope = Private
	#tag EndConstant

	#tag Constant, Name = libbrotlienc, Type = String, Dynamic = False, Default = \"libbrotlienc", Scope = Private
	#tag EndConstant


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
